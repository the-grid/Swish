import Foundation
import Argo
import Result

public struct APIClient: Client {
  private let requestPerformer: RequestPerformer

  public let queue: dispatch_queue_t?

  public init(requestPerformer: RequestPerformer = NetworkRequestPerformer(), queue: dispatch_queue_t? = dispatch_get_main_queue()) {
    self.requestPerformer = requestPerformer
    self.queue = queue
  }

  public func performRequest<T: Request>(request: T, completionHandler: Result<T.ResponseObject, SwishError> -> Void) -> NSURLSessionDataTask {
    return requestPerformer.performRequest(request.build()) { [queue] result in
      let object = result >>- deserialize >>- request.parse

      if let queue = queue {
        dispatch_async(queue) { completionHandler(object) }
      } else {
        completionHandler(object)
      }
    }
  }
}

private func deserialize(response: HTTPResponse) -> Result<JSON, SwishError> {
  let json = parseJSON(response)

  switch (response.code, json) {

  case let (_, .Failure(e)):
    return .Failure(e)

  case let (200...299, .Success(j)):
    return .Success(JSON(j))

  case let (code, .Success(j)):
    return .Failure(.ServerError(code: code, json: j))
  }
}

private func parseJSON(response: HTTPResponse) -> Result<AnyObject, SwishError> {
  guard let data = response.data where data.length > 0 else {
    return .Success(NSNull())
  }

  let result = materialize(
    try NSJSONSerialization
      .JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
  )

  return result.mapError(SwishError.InvalidJSONResponse)
}

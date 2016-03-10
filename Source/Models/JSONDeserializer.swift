import Argo
import Result

struct JSONDeserializer: Deserializer {
  func deserialize<T : Request>(request: T) -> (NSData?) -> Result<T.Decoder.Representation, SwishError> {
    return { (data: NSData?) -> Result<T.Decoder.Representation, SwishError> in
      let json = self.parseJSON(data)

      switch json {
      case let .Failure(e):
        return .Failure(.InvalidJSONResponse(e))
      case let .Success(j):
        return .Success(T.Decoder.parse(j))
      }
    }
  }
}

extension JSON: Parser {
  public typealias Representation = JSON
  public static func parse(j: AnyObject) -> JSON {
    return JSON.init(j)
  }
}

private extension JSONDeserializer {
  private func parseJSON(data: NSData?) -> Result<AnyObject, NSError> {
    guard let d = data where d.length > 0 else {
      return .Success(NSNull())
    }

    return Result(
      try NSJSONSerialization
        .JSONObjectWithData(d, options: NSJSONReadingOptions(rawValue: 0))
    )
  }
}

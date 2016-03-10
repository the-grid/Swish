import Foundation
import Argo
import Result

public protocol Client {
  var deserializer: Deserializer { get }

  func performRequest<T: Request>(request: T, completionHandler: Result<T.ResponseObject, SwishError> -> ()) -> NSURLSessionDataTask
}

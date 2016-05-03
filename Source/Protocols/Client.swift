import Foundation
import Argo
import Result

public protocol Client {
  var queue: dispatch_queue_t? { get }
  func performRequest<T: Request>(request: T, completionHandler: Result<T.ResponseObject, SwishError> -> ()) -> NSURLSessionDataTask
}

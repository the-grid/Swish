import Result

public protocol Deserializer {
  func deserialize<T: Request>(request: T) -> (NSData?) -> Result<T.ResponseParser.Representation, SwishError>
}

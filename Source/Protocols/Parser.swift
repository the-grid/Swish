public protocol Parser {
  associatedtype Representation
  static func parse(j: AnyObject) -> Representation
}

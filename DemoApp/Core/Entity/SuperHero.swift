
/// Represents a single Marvel Series.
public struct Character: Codable, Equatable {
    
  public let name: String

  public init(name: String) {
    self.name = name
  }
}

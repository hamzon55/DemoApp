/// Represents a single Marvel Series.
public struct Character: Codable, Equatable {
    
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
    
    init(id: Int, name: String, description: String,  thumbnail: Thumbnail) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
    }
    
    var descriptionText: String {
        return description.isEmpty == false ? description : "Description not available."
        }
}

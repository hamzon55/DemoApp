import Foundation

struct Thumbnail: Codable, Equatable {
    
    let path: String
    let thumbnailExtension: String
    
    var fullPath: String {
        return "\(path).\(thumbnailExtension)"
    }
    
    var url: URL? { URL(string: "\(path).\(thumbnailExtension)") }

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

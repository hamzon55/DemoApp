
import Foundation

enum HeroeEndpoint: APIEndpoint {
    case getHeroes
    
    var baseURL: URL {
        return URL(string: "https://example.com/api")!
    }
    
    var path: String {
        switch self {
        case .getHeroes:
            return "/users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHeroes:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getHeroes:
            return ["Authorization": "Bearer TOKEN"]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getHeroes:
            return ["page": 1, "limit": 10]
        }
    }
}

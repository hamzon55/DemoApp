import Foundation

enum HeroeEndpoint: APIEndpoint {
    
    case getHeroes(query: String?)

    var baseURL: URL {
        return MarvelConstants.baseUrl
    }
    
    var path: String {
        switch self {
        case .getHeroes:
            return MarvelConstants.characterPath
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
            return ["Content-Type": "application/json"]
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [
            "ts": MarvelConstants.timestamp,
            "apikey": MarvelConstants.apiKey,
            "hash": MarvelConstants.hash
        ]
        
        if case let .getHeroes(query) = self, let query = query, !query.isEmpty {
            params["nameStartsWith"] = query
        }
        
        return params.isEmpty ? nil : params
    }
}

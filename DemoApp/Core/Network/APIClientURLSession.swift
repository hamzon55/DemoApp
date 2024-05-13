import Foundation
import Combine


class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    func request<T>(_ endpoint: EndpointType) -> AnyPublisher<T, any Error> where T : Decodable {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = endpoint.parameters?.map { key, value in
            URLQueryItem(name: key, value: String(describing: value))
        }
        var request = URLRequest(url: components?.url ?? url)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return session.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .tryMap { data -> T in
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    print(error)
                    throw APIError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

import XCTest
import Combine
@testable import DemoApp

class MockAPIClient<EndpointType: APIEndpoint>: APIClient {
    
    var requestCalled = false
    var requestEndpoint: APIEndpoint?
    var requestResult: AnyPublisher<Any, APIError>?
    
    func request<T>(_ endpoint: EndpointType) -> AnyPublisher<T, any Error> where T : Decodable {
        requestCalled = true
        requestEndpoint = endpoint
        guard let requestResult = requestResult else {
            return Fail<T, Error>(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        return requestResult
            .tryMap { result in
                guard let result = result as? T else {
                    throw APIError.invalidResponse
                }
                return result
            }
            .eraseToAnyPublisher()
    }
}

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

enum APIConfig {
    static let apiKey = "8240ecf5-faa7-4169-9bea-b8245f858991"
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()
    
    static func makeClient() throws -> Client {
        Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        )
    }
}

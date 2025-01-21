//
//  Endpoint.swift
//  UserInfo
//
//  Created by Trong/Corbin/서비스개발팀 on 1/21/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    
    func urlRequest() throws -> URLRequest
}

extension Endpoint {
    func urlRequest() throws -> URLRequest {
        // Path
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        // HTTP Method
        request.httpMethod = method.rawValue
        // Header
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        // Parameter
        if let parameters = parameters {
            switch method {
            case .get:
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.url = urlComponents?.url
            default:
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            }
        }
        
        return request
    }
}

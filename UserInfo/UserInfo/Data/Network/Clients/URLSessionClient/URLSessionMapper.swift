//
//  DataMapper.swift
//  UserInfo
//
//  Created by Trong/Corbin/서비스개발팀 on 1/21/25.
//

import Foundation

/// Error can be extended based on defination cases in specific network clients
enum URLSessionError: Error {
    case invalidResponse
    case noData
}

protocol URLSessionMapper {
    func mapData<T: Decodable>(_ type: T.Type, data: Data?, response: URLResponse?) throws -> T
}

/// This is default mapping behavior, this behavior can be changed by override in custom mapper
extension URLSessionMapper {
    func mapData<T: Decodable>(_ type: T.Type, data: Data?, response: URLResponse?) throws -> T {
        /// HTTP response handing
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLSessionError.invalidResponse
        }
        /// Data handing
        guard let data = data else {
            throw URLSessionError.noData
        }
        /// Try to decode data
        return try JSONDecoder().decode(T.self, from: data)
    }
}

/// Using Default mapData() function, so don't need to override in this case
struct DefaultURLSessionMapper: URLSessionMapper {}

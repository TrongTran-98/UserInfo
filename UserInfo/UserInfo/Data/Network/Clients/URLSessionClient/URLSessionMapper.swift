//
//  DataMapper.swift
//  UserInfo
//
//  Created by Trong/Corbin/서비스개발팀 on 1/21/25.
//

import Foundation

protocol URLSessionMapper {
    func mapData<T: Decodable>(_ type: T.Type, error: Error?, data: Data?, response: URLResponse?) throws -> T
}

/// This is default mapping behavior, this behavior can be changed by override in custom mapper
extension URLSessionMapper {
    func mapData<T: Decodable>(_ type: T.Type, error: Error?, data: Data?, response: URLResponse?) throws -> T {
        /// Catch error if needed
        if let error = error {
            print("Error undefined error \(error.localizedDescription)")
            let nsError = error as NSError
            if nsError.code == -1009 {
                throw URLSessionError.noInternet
            } else {
                throw URLSessionError.undefined(error)
            }
        }
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

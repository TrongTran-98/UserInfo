//
//  NetworkClient.swift
//  UserInfo
//
//

import Foundation

protocol NetworkClient {
    
    /// - Parameters:
    ///   - endpoint: The endpoint to provide expected request
    ///   - completion: completion callback
    ///   - note: We can be able to use flexible methods to get the callback datas (ex: Combine, RxSwift, etc...), in this case we gonna use completion trailing closure to make it
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}

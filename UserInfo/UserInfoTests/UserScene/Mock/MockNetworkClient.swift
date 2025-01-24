//
//  MockUserService.swift
//  UserInfo
//
//  Created by Trong/Corbin/서비스개발팀 on 1/23/25.
//

@testable import UserInfo

import Foundation
import XCTest

enum UserTestCase {
    case fetchUsersSuccess
    case fetchUserDetailSuccess
    case noInternetError
    case unknowError
    case noDataError
}

class MockNetworkClient: NetworkClient {

    var requestCount: Int = 0
    var testCase: UserTestCase = .fetchUsersSuccess
    var mapper: URLSessionMapper = DefaultURLSessionMapper()
    
    func request<T>(_ endpoint: Endpoint, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        
        // Increase call times
        self.requestCount += 1
        
        // Send result
        switch testCase {
        case .fetchUsersSuccess, .fetchUserDetailSuccess:
            guard let data = testCase == .fetchUsersSuccess ? localUsersJsonData() : localUserDetailData() else { return }
            do {
                let decodedModel = try self.mapper.mapData(T.self, error: nil, data: data, response: nil)
                completion(.success(decodedModel))
            } catch {
                completion(.failure(error))
            }
        case .noInternetError:
            completion(.failure(URLSessionError.noInternet))
        case .unknowError:
            completion(.failure(URLSessionError.undefined(NSError(domain: "unknow", code: 09))))
        case .noDataError:
            completion(.failure(URLSessionError.noData))
        }
    }
    
    private func localUsersJsonData() -> Data? {
        guard let url = Bundle.main.url(forResource: "Users", withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
    
    private func localUserDetailData() -> Data? {
        guard let url = Bundle.main.url(forResource: "UserDetail", withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}

struct MockMapper: URLSessionMapper {
    func mapData<T>(_ type: T.Type, error: (any Error)?, data: Data?, response: URLResponse?) throws -> T where T : Decodable {
        guard let data = data else {
            throw URLSessionError.noData
        }
        /// Return decoded model
        return try JSONDecoder().decode(T.self, from: data)
    }
}

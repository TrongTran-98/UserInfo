//
//  MockUserService.swift
//  UserInfo
//

@testable import UserInfo
import Foundation

struct MockEndpoint: Endpoint {
    
    var baseURL: URL { return URL(string: "http://mockendpoint.com")!}
    
    var path: String { return "" }
    
    var method: UserInfo.HTTPMethod { return .get}
    
    var headers: [String : String]? { return nil }
    
    var parameters: [String : Any]? { return nil }
    
}

class MockUserService: UserService {
    
    private let client = MockNetworkClient()
    
    var expectResult: UserTestCase = .fetchUsersSuccess
    
    func fetchUsers(pageSize: Int, sinceId: Int, completion: @escaping (Result<[UserInfo.User], any Error>) -> Void) {
        client.testCase = expectResult
        client.request(MockEndpoint(), completion: completion)
    }
    
    func fetchUserDetail(loginName: String, completion: @escaping (Result<UserInfo.User, any Error>) -> Void) {
        client.testCase = expectResult
        client.request(MockEndpoint(), completion: completion)
    }
}

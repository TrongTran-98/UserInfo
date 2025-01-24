//
//  MockRepository.swift
//  UserInfo
//

@testable import UserInfo

final class MockRepository: UserRepository {
    
    private let service = MockUserService()
    
    var expectResult: UserTestCase = .fetchUsersSuccess
    
    func fetchUsers(pageSize: Int, sinceId: Int, completion: @escaping (Result<[UserInfo.User], any Error>) -> Void) {
        service.expectResult = self.expectResult
        service.fetchUsers(pageSize: pageSize, sinceId: sinceId, completion: completion)
    }
    
    func fetchUserDetail(loginName: String, completion: @escaping (Result<UserInfo.User, any Error>) -> Void) {
        service.expectResult = self.expectResult
        service.fetchUserDetail(loginName: loginName, completion: completion)
    }
}

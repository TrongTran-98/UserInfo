//
//  UserService.swift
//  UserInfo
//

protocol UserService {
    
    func fetchUsers(pageSize: Int, sinceId: Int, completion: @escaping (Result<[User], Error>) -> Void)
    
    func fetchUserDetail(loginName: String, completion: @escaping (Result<User, Error>) -> Void)
    
}

// MARK: - Service Implementation

class UserServiceImpletation: UserService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = URLSessionClient()) {
        self.networkClient = networkClient
    }
    
    func fetchUsers(pageSize: Int, sinceId: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        networkClient.request(UserEndpoint.users(pageItemCount: pageSize, lastId: sinceId), completion: completion)
    }
    
    func fetchUserDetail(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        networkClient.request(UserEndpoint.userDetail(loginName: loginName), completion: completion)
    }
}

//
//  DefaultUserRepository.swift
//  UserInfo
//
//  Created by Trong/Corbin/서비스개발팀 on 1/21/25.
//

final class DefaultUserRepository {
    
    private let storageCache: UserStorage
    private let service: UserService
    
    init(storage: UserStorage = RealmStorage.shared, service: UserService = UserServiceImpletation()) {
        self.storageCache = storage
        self.service = service
    }

}

// MARK: - UserReposity

extension DefaultUserRepository: UserRepository {
    
    /// Fetch Users
    /// - Parameters:
    ///   - pageSize: number of items per page
    ///   - sinceId: last displayed id
    ///   - completion: result callback
    func fetchUsers(pageSize: Int, sinceId: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        // Offline mode is checked in the first page
        if sinceId == 0 && !NWMonitorHelper.shared.isConnected {
            print("Loading data from cache because there is no internet")
            storageCache.fetchAllUsers(completion: completion)
        } else {
        // Online mode -> Let's call API
            print("Call API to get new data since id \(sinceId)")
            service.fetchUsers(pageSize: pageSize, sinceId: sinceId, completion: { [weak self] result in
                guard let self = self else { return }
                completion(result)
                // Save to storage if this is the first page
                if sinceId != 0 { return }
                switch result {
                case .success(let users):
                    self.storageCache.saveUsers(users)
                case .failure(_ ):
                    return
                }
            })
        }
    }
    
    /// Fetch user detail
    /// - Parameters:
    ///   - loginName: login name of user
    ///   - completion: result callback
    func fetchUserDetail(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        service.fetchUserDetail(loginName: loginName, completion: completion)
    }
    
}

//
//  UserUsecase.swift
//  UserInfo
//

protocol UserUsecase {
    var userRepository: UserRepository { get }
}

// MARK: - Fetch Users Usecase
protocol FetchUsersUsecase: UserUsecase {
    func fetchUsers(pageSize: Int, sinceId: Int, completion: @escaping (Result<[User], Error>) -> Void)
}

extension FetchUsersUsecase {
    func fetchUsers(pageSize: Int, sinceId: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        userRepository.fetchUsers(pageSize: pageSize, sinceId: sinceId, completion: completion)
    }
}

class DefaultFetchUsersUsecase: FetchUsersUsecase {
    var userRepository: UserRepository
    
    init(userRepository: UserRepository = DefaultUserRepository()) {
        self.userRepository = userRepository
    }
}

// MARK: - Fetch User Details
protocol FetchUserDetailsUsecase: UserUsecase {
    func fetchUserDetail(loginName: String, completion: @escaping (Result<User, Error>) -> Void)
}

extension FetchUserDetailsUsecase {
    func fetchUserDetail(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        userRepository.fetchUserDetail(loginName: loginName, completion: completion)
    }
}

class DefaultFetchUserDetailsUsecase: FetchUserDetailsUsecase {
    var userRepository: UserRepository
    
    init(userRepository: UserRepository = DefaultUserRepository()) {
        self.userRepository = userRepository
    }
}

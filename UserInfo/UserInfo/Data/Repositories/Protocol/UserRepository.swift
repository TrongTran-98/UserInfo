//
//  UserRepository.swift
//  UserInfo
//
//  Created by Trong/Corbin/서비스개발팀 on 1/21/25.
//

protocol UserRepository {
    
    func fetchUsers(pageSize: Int, sinceId: Int, completion: @escaping (Result<[User], Error>) -> Void)
    
    func fetchUserDetail(loginName: String, completion: @escaping (Result<User, Error>) -> Void)
    
}

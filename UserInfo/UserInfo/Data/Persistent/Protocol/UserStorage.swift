//
//  UserStorage.swift
//  UserInfo
//
//

protocol UserStorage {
    
    /// Save list users
    /// - Parameter user: The list users to save
    func saveUsers(_ users: [User])
    
    /// Fetch list users
    func fetchAllUsers(completion: @escaping (Result<[User], Error>) -> Void)
    
    /// Remove all user
    func removeAllUsers(completion: @escaping (Result<Void, Error>) -> Void)
    
}

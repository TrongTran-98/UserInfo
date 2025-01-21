//
//  UserDefaultStorage.swift
//  UserInfo
//
//

import Foundation

enum UserDefaultError: Error {
    case nonData
}

class UserDefaultStorage {
    
    static let shared: UserDefaultStorage = UserDefaultStorage()
    
    private let userStorageKey: String = "local_users"
    private let storageQueue = DispatchQueue(label: "default_storage", qos: .background)
    
}

extension UserDefaultStorage: UserStorage {
    
    func saveUsers(_ users: [User]) {
        storageQueue.async { [unowned self] in
            guard let encodedData = try? JSONEncoder().encode(users) else { return }
            /// Save data into UserDefault
            UserDefaults.standard.set(encodedData, forKey: self.userStorageKey)
        }
    }
    
    func fetchAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        storageQueue.async { [unowned self] in
            do {
                guard let encodedData = UserDefaults.standard.data(forKey: self.userStorageKey) else {
                    completion(.failure(UserDefaultError.nonData))
                    return
                }
                let users = try JSONDecoder().decode([User].self, from: encodedData)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func removeAllUsers(completion: @escaping (Result<Void, Error>) -> Void) {
        storageQueue.async { [unowned self] in
            UserDefaults.standard.removeObject(forKey: self.userStorageKey)
        }
    }
    
}

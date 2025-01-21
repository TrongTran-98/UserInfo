//
//  RealmStorage.swift
//  UserInfo
//
//

import Foundation
import RealmSwift

class RealmStorage {
    
    static let shared = RealmStorage()
    
    private let realm: Realm? = try? Realm()
    
}

extension RealmStorage: UserStorage {
    
    func saveUsers(_ users: [User]) {
        do {
            try realm?.write { [weak self] in
                guard let self = self else { return }
                /// Remove old users
                if let users = realm?.objects(RealmUser.self) {
                    self.realm?.delete(users)
                }
                /// Add new users
                self.realm?.add(users.map({ RealmUser(user: $0) }))
            }
        } catch {
            print("Realm save error - \(error.localizedDescription)")
        }
    }
    
    func fetchAllUsers(completion: @escaping (Result<[User], any Error>) -> Void) {
        guard let users = realm?.objects(RealmUser.self) else {
            completion(.success([]))
            return
        }
        completion(.success(users.map(\.user)))
    }
    
    func removeAllUsers(completion: @escaping (Result<Void, any Error>) -> Void) {
        do {
            // Check if existing users
            guard let users = realm?.objects(RealmUser.self) else {
                completion(.success(()))
                return
            }
            // Try to delete
            try realm?.write { [weak self] in
                guard let self = self else { return }
                self.realm?.delete(users)
            }
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
}

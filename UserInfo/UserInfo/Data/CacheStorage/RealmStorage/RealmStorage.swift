//
//  RealmStorage.swift
//  UserInfo
//
//

import Foundation
import RealmSwift

class RealmStorage {
    
    static let shared = RealmStorage()
    
    private let realm: Realm?
    private let nwMonitor: NWMonitor
    
    init(realm: Realm? = try? Realm(), nwMonitor: NWMonitor = NWMonitorHelper.shared) {
        self.realm = realm
        self.nwMonitor = nwMonitor
    }
}

extension RealmStorage: UserStorage {
    
    func saveUsers(_ users: [User]) {
        DispatchQueue.main.async {
            do {
                try self.realm?.write { [weak self] in
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
    }
    
    func fetchAllUsers(completion: @escaping (Result<[User], any Error>) -> Void) {
        DispatchQueue.main.async {
            guard let users = self.realm?.objects(RealmUser.self) else {
                if !self.nwMonitor.isConnected {
                    completion(.failure(URLSessionError.noInternet))
                } else {
                    completion(.success([]))
                }
                return
            }
            if users.isEmpty && !self.nwMonitor.isConnected { completion(.failure(URLSessionError.noInternet)); return}
            completion(.success(users.map(\.user)))
        }
    }
    
    func removeAllUsers(completion: @escaping (Result<Void, any Error>) -> Void) {
        DispatchQueue.main.async {
            do {
                // Check if existing users
                guard let users = self.realm?.objects(RealmUser.self) else {
                    completion(.success(()))
                    return
                }
                // Try to delete
                try self.realm?.write { [weak self] in
                    guard let self = self else { return }
                    self.realm?.delete(users)
                }
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}

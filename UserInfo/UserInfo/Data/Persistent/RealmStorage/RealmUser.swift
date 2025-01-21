//
//  RealmUser.swift
//  UserInfo
//
//

import Foundation
import RealmSwift

class RealmUser: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var login: String?
    @Persisted var avatarUrl: String?
    @Persisted var htmlUrl: String?
    @Persisted var location: String?
    @Persisted var followers: Int?
    @Persisted var following: Int?
    
    convenience init(user: User) {
        self.init()
        self.id = user.id
        self.login = user.login
        self.avatarUrl = user.avatarUrl
        self.location = user.location
        self.htmlUrl = user.htmlUrl
        self.followers = user.followers
        self.following = user.following
    }
    
    var user: User {
        return User(id: id,
                    login: login,
                    avatarUrl: avatarUrl,
                    htmlUrl: htmlUrl,
                    location: location,
                    followers: followers,
                    following: following)
    }
}

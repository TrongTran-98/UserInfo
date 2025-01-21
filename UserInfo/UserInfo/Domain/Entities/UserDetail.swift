//
//  UserDetail.swift
//  UserInfo
//

import Foundation

struct UserDetail: Codable {

    let id: Int
    let login: String?
    let avatarUrl: String?
    let htmlUrl: String?
    let location: String?
    let followers: Int?
    let following: Int?

    private enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case location = "location"
        case followers = "followers"
        case following = "following"
    }
    
}

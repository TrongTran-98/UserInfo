//
//  User.swift
//  UserInfo
//

import Foundation

struct User: Codable {

    let id: Int
    let login: String
    let avatarUrl: String?
    let htmlUrl: String?

    private enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }

}

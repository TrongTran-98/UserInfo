//
//  UserEndpoint.swift
//  UserInfo
//
//

import Foundation

enum UserEndpoint {
    
    /// List users
    case users(pageItemCount: Int, lastId: Int)
    /// User detail
    case userDetail(loginName: String)
    
}

extension UserEndpoint: Endpoint {
    
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    var path: String { return "/users" }
    
    var method: HTTPMethod { return .get }
    
    var headers: [String : String]? { return ["Content-Type" : "application/json;charset=utf-8"] }
    
    var parameters: [String : Any]? {
        switch self {
        case .users(let perPage, let sinceId):
            return ["per_page": perPage, "since": sinceId]
        case .userDetail(let loginName):
            return ["login_username": loginName]
        }
    }
    
}

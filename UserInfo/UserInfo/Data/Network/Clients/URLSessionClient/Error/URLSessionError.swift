//
//  URLSessionError.swift
//  UserInfo
//
//  Created by Corbin on 22/1/25.
//

import Foundation

/// Error can be extended based on defination cases in specific network clients
enum URLSessionError: Error {
    case invalidResponse
    case noData
    case noInternet
    case undefined(Error)
    
    var description: String {
        switch self {
        case .invalidResponse:
            return "Invalid Response"
        case .noData:
            return "No Data"
        case .noInternet:
            return "No Internet Connection"
        case .undefined(let error):
            return error.localizedDescription
        }
    }
}

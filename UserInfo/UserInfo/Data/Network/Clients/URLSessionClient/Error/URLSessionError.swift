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
    case undefined(Error)
}

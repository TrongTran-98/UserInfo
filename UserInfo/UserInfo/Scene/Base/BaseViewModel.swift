//
//  BaseViewModel.swift
//  UserInfo
//
//

import Foundation
import Combine

class BaseViewModel {
    
    /// The error publisher to send to View
    let errorPublisher: PassthroughSubject<Error, Never> = PassthroughSubject()
    
    /// Error handling
    /// - Parameter error: The error to handle
    func handleError(_ error: Error) {
        /// Do something before send to view (Ex: Analytics, Logging, etc ...)
        /// .....
        /// Send to view
        errorPublisher.send(error)
    }
}

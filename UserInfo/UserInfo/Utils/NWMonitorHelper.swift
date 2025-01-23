//
//  NetworkHelper.swift
//  UserInfo
//
//

import Foundation
import Network

protocol NWMonitor {
    var isConnected: Bool { get set }
    var isUsingCellular: Bool { get set }
}

class NWMonitorHelper: NWMonitor {
    
    static let shared: NWMonitorHelper = NWMonitorHelper()
    
    var isConnected: Bool = false
    var isUsingCellular: Bool = false
    
    init() {
        setupNetwork()
    }
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    var onNetworkState: ((_ isConnected: Bool) -> Void)?

    private func setupNetwork() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // Network is available
                self.onNetworkState?(true)
                self.isConnected = true
                self.isUsingCellular = path.usesInterfaceType(.cellular)
            } else {
                // No network connection
                self.onNetworkState?(false)
                self.isConnected = false
                self.isUsingCellular = false
            }
        }
        
        monitor.start(queue: queue)
    }
    
}

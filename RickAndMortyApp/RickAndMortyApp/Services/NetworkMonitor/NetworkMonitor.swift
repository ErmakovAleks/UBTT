//
//  NetworkMonitor.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import Foundation
import Network


protocol NetworkMonitorProtocol {
    
    var isConnected: Bool { get }
    
    static var shared: Self { get }
}

extension Notification.Name {
    
    static let NetworkStatusChanged = Notification.Name("NetworkStatusChanged")
}

final class NetworkMonitor: NetworkMonitorProtocol {
    
    // MARK: -
    // MARK: Variables
    
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private(set) var isConnected: Bool = false
    private(set) var connectionType: ConnectionType = .unknown

    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case other
        case unknown
    }
    
    // MARK: -
    // MARK: Initialization

    private init() {
        self.monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.connectionType = self?.getConnectionType(from: path) ?? .unknown
            NotificationCenter.default.post(name: .NetworkStatusChanged, object: nil)
        }
        
        self.monitor.start(queue: queue)
    }
    
    // MARK: -
    // MARK: Private Functions

    private func getConnectionType(from path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.other) {
            return .other
        } else {
            return .unknown
        }
    }
}

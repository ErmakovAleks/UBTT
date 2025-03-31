//
//  ServiceContainer.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

protocol WorkerDI {
    
    static var networkMonitor: NetworkMonitorProtocol { get }
    static var networkService: NetworkSessionProtocol { get }
    static var persistenceService: PersistenceServiceProtocol { get }
}

enum DIContainer: WorkerDI {
    
    static var networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared
    static var networkService: NetworkSessionProtocol = NetworkService.shared
    static var persistenceService: PersistenceServiceProtocol = PersistenceService.shared
}

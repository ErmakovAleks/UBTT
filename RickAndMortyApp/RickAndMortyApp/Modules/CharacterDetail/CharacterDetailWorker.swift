//
//  CharacterDetailWorker.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import Foundation


protocol CharacterDetailWorkerProtocol {
    
    func loadCharacter(id: Int, completion: @escaping (Result<Character_, RequestError>) -> Void)
}

final class CharacterDetailWorker: CharacterDetailWorkerProtocol {
    
    // MARK: -
    // MARK: Variables
    
    private let networkMonitor: NetworkMonitorProtocol
    private let networkService: NetworkSessionProtocol
    private let persistenceService: PersistenceServiceProtocol
    
    // MARK: -
    // MARK: Initialization
    
    init(container: WorkerDI.Type) {
        self.networkMonitor = container.networkMonitor
        self.networkService = container.networkService
        self.persistenceService = container.persistenceService
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleNetworkRestored),
            name: .NetworkStatusChanged,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadCharacter(id: Int, completion: @escaping (Result<Character_, RequestError>) -> Void) {
        if self.networkMonitor.isConnected {
            let params = CharacterParams(id: id)
            self.networkService.sendRequest(requestModel: params) { result in
                switch result {
                case .success(let response):
                    completion(result)
                case .failure(_):
                    if let character = self.persistenceService.loadCharacter(by: id) {
                        completion(.success(character))
                    } else {
                        completion(.failure(.noResponse))
                    }
                }
            }
        } else {
            if let character = self.persistenceService.loadCharacter(by: id) {
                completion(.success(character))
            } else {
                completion(.failure(.noResponse))
            }
        }
    }
    
    // MARK: -
    // MARK: Private Functions
    
    @objc private func handleNetworkRestored() {
        if NetworkMonitor.shared.isConnected {
            // Онлайн: грузим из API
        } else {
            // Офлайн: грузим из CoreData
        }
    }
}

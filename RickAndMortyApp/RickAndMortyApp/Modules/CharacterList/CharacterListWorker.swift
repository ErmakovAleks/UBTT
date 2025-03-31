//
//  CharacterListWorker.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import Foundation

protocol CharacterListWorkerProtocol {
    
    func loadCharacters(page: Int, completion: @escaping ([Character_]) -> Void)
}

final class CharacterListWorker: CharacterListWorkerProtocol {
    
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
    
    // MARK: -
    // MARK: Character List Worker Protocol

    func loadCharacters(page: Int, completion: @escaping ([Character_]) -> Void) {
        if self.networkMonitor.isConnected {
        let params = CharactersParams(page: page)
            self.networkService.sendRequest(requestModel: params) { result in
                switch result {
                case .success(let response):
                    completion(response.results)
                case .failure(_):
                    completion(self.persistenceService.loadCharacters())
                }
            }
        } else {
            completion(self.persistenceService.loadCharacters())
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

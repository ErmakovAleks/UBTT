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
    
    private var networkMonitor: NetworkMonitorProtocol
    private let networkService: NetworkSessionProtocol
    private let persistenceService: PersistenceServiceProtocol
    
    private var lastRequestedCharacterID: Int?
    private var pendingCompletion: ((Result<Character_, RequestError>) -> Void)?
    
    // MARK: -
    // MARK: Initialization
    
    init(container: WorkerDI.Type) {
        self.networkMonitor = container.networkMonitor
        self.networkService = container.networkService
        self.persistenceService = container.persistenceService
        
        self.networkMonitor.isConnectedHandler = { [weak self] isConnected in
            if isConnected, let lastRequestedCharacterID = self?.lastRequestedCharacterID {
                self?.handleNetworkRestored()
            }
        }
    }
    
    func loadCharacter(id: Int, completion: @escaping (Result<Character_, RequestError>) -> Void) {
        self.lastRequestedCharacterID = id
        
        if self.networkMonitor.isConnected {
            let params = CharacterParams(id: id)
            self.networkService.sendRequest(requestModel: params) { result in
                switch result {
                case .success(let character):
                    self.persistenceService.saveCharacters([character])
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
            self.pendingCompletion = completion
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
        if self.networkMonitor.isConnected {
            guard let id = lastRequestedCharacterID, let completion = pendingCompletion else { return }
            
            let params = CharacterParams(id: id)
            self.networkService.sendRequest(requestModel: params) { result in
                if case .success(let character) = result {
                    self.persistenceService.saveCharacters([character])
                }
                
                completion(result)
            }
        }
    }
}

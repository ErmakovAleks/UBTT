//
//  CharacterListWorker.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import Foundation


protocol CharacterListWorkerProtocol {
    
    func loadCharacters(page: Int, completion: @escaping (Result<[Character_], RequestError>) -> Void)
}

final class CharacterListWorker: CharacterListWorkerProtocol {
    
    // MARK: -
    // MARK: Variables
    
    private var networkMonitor: NetworkMonitorProtocol
    private let networkService: NetworkSessionProtocol
    private let persistenceService: PersistenceServiceProtocol
    
    private var lastRequestedPage: Int?
    private var pendingCompletion: ((Result<[Character_], RequestError>) -> Void)?
    
    // MARK: -
    // MARK: Initialization
    
    init(container: WorkerDI.Type) {
        self.networkMonitor = container.networkMonitor
        self.networkService = container.networkService
        self.persistenceService = container.persistenceService
        
        self.networkMonitor.isConnectedHandler = { [weak self] isConnected in
            if isConnected, let lastRequestedPage = self?.lastRequestedPage {
                self?.handleNetworkRestored()
            }
        }
    }
    
    // MARK: -
    // MARK: Character List Worker Protocol

    func loadCharacters(page: Int, completion: @escaping (Result<[Character_], RequestError>) -> Void) {
        self.lastRequestedPage = page
        
        if self.networkMonitor.isConnected {
        let params = CharactersParams(page: page)
            self.networkService.sendRequest(requestModel: params) { result in
                switch result {
                case .success(let response):
                    self.persistenceService.saveCharacters(response.results)
                    completion(.success(response.results))
                case .failure(_):
                    self.tryGetFromCache(completion: completion)
                }
            }
        } else {
            self.pendingCompletion = completion
            self.tryGetFromCache(completion: completion)
        }
    }
    
    // MARK: -
    // MARK: Private Functions
    
    private func tryGetFromCache(
        completion: @escaping (Result<[Character_], RequestError>) -> Void
    ) {
        let characters = self.persistenceService.loadCharacters()
        if !characters.isEmpty {
            completion(.success(characters))
        } else {
            completion(.failure(.noResponse))
        }
    }
    
    @objc private func handleNetworkRestored() {
        if self.networkMonitor.isConnected {
            guard let page = lastRequestedPage, let completion = pendingCompletion else { return }
            
            let params = CharactersParams(page: page)
            self.networkService.sendRequest(requestModel: params) { result in
                if case .success(let characters) = result {
                    self.persistenceService.saveCharacters(characters.results)
                    completion(.success(characters.results))
                } else {
                    completion(.failure(.unknown("<!> Unknown error")))
                }
            }
        }
    }
}

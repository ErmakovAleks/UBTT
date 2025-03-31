//
//  CharacterListInteractor.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

protocol CharacterListInteractorProtocol {
    
    func fetchCharacters(request: CharacterList.Fetch.Request)
    
    func requestNextPage()
}

final class CharacterListInteractor: CharacterListInteractorProtocol {
    
    // MARK: -
    // MARK: Variables
    
    var presenter: CharacterListPresentationLogic?
    var worker: CharacterListWorkerProtocol?
    
    private var currentPage = 0
    private var isLoading = false
    private var hasMorePages = true
    
    // MARK: -
    // MARK: Character List Interactor Protocol

    func fetchCharacters(request: CharacterList.Fetch.Request) {
        guard !self.isLoading else { return }
        self.isLoading = true
        
        self.worker?.loadCharacters(page: self.currentPage) { [weak self] result in
            self?.isLoading = false
            
            switch result {
            case .success(let characters):
                let response = CharacterList.Fetch.Response(characters: characters)
                self?.presenter?.presentCharacters(response: response)
            case .failure(let error):
                self?.presenter?.presentError(response: .init(error: error))
            }
        }
    }
    
    func requestNextPage() {
        guard hasMorePages else { return }
        self.currentPage += 1
        self.fetchCharacters(request: .init())
    }
}

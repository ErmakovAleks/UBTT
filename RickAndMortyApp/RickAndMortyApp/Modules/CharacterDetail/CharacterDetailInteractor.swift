//
//  CharacterDetailInteractor.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

protocol CharacterDetailInteractorProtocol {
    
    func fetchCharacter(request: CharacterDetail.Show.Request)
}

final class CharacterDetailInteractor: CharacterDetailInteractorProtocol {
    
    // MARK: -
    // MARK: Variables
    
    var presenter: CharacterDetailPresentationLogic?
    var worker: CharacterDetailWorkerProtocol?
    
    private let characterID: Int
    
    init(characterID: Int) {
        self.characterID = characterID
    }

    // MARK: -
    // MARK: Character Detail Interactor Protocol

    func fetchCharacter(request: CharacterDetail.Show.Request) {
        self.worker?.loadCharacter(id: self.characterID) { [weak self] result in
            guard let self, case let .success(character) = result else { return }
            self.presenter?.presentCharacter(response: .init(character: character))
        }
    }
}

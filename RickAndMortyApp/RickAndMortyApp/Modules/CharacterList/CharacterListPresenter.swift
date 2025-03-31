//
//  CharacterListPresenter.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import Foundation

protocol CharacterListPresentationLogic {
    
    func presentCharacters(response: CharacterList.Fetch.Response)
}

final class CharacterListPresenter: CharacterListPresentationLogic {
    
    // MARK: -
    // MARK: Variables
    
    weak var viewController: CharacterListViewController?
    
    // MARK: -
    // MARK: Functions

    func presentCharacters(response: CharacterList.Fetch.Response) {
        let viewModel = CharacterList.Fetch.ViewModel(
            displayedCharacters: response.characters.map {
                .init(
                    id: $0.id,
                    name: $0.name,
                    gender: $0.gender.rawValue,
                    origin: $0.origin.name,
                    imageURL: URL(string: $0.image)
                )
            }
        )
        
        self.viewController?.displayCharacters(viewModel: viewModel)
    }
}

//
//  CharacterDetailPresenter.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

protocol CharacterDetailPresentationLogic {
    
    func presentCharacter(response: CharacterDetail.Show.Response)
}

final class CharacterDetailPresenter: CharacterDetailPresentationLogic {
    
    // MARK: -
    // MARK: Variables
    
    weak var viewController: CharacterDetailViewController?

    // MARK: -
    // MARK: Character Detail Presentation Protocol
    
    func presentCharacter(response: CharacterDetail.Show.Response) {
        let character = response.character
        let viewModel = CharacterDetail.Show.ViewModel(
            name: character.name,
            gender: character.gender.rawValue,
            origin: character.origin.name,
            status: character.status.rawValue,
            imageURL: character.image
        )
        
        self.viewController?.displayCharacter(viewModel: viewModel)
    }
}

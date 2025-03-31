//
//  CharacterDetailPresenter.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

protocol CharacterDetailPresentationLogic {
    
    func presentCharacter(response: CharacterDetail.Show.Response)
    
    func presentError(response: CharacterDetail.Error.Response)
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
    
    func presentError(response: CharacterDetail.Error.Response) {
            let message: String

            switch response.error {
            case .noResponse:
                message = "No response from server. Please, try later"
            case .decode:
                message = "Parsing data error"
            case .unauthorized:
                message = "No authorized"
            case .unexpectedStatusCode(let url):
                message = "Server sent error. URL: \(url)"
            case .failure(let err):
                message = err.localizedDescription
            case .unknown:
                message = "Unknown error"
            case .invalidURL:
                message = "Invalid URL"
            }

        self.viewController?.displayError(viewModel: .init(message: message))
    }
}

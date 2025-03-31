//
//  CharacterListPresenter.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import Foundation

protocol CharacterListPresentationLogic {
    
    func presentCharacters(response: CharacterList.Fetch.Response)
    
    func presentError(response: CharacterList.Error.Response)
}

final class CharacterListPresenter: CharacterListPresentationLogic {
    
    // MARK: -
    // MARK: Variables
    
    weak var viewController: CharacterListViewController?
    
    // MARK: -
    // MARK: Character List Presentation Logic

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
    
    func presentError(response: CharacterList.Error.Response) {
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

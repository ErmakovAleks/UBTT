//
//  CharacterDetailBuilder.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import UIKit


enum CharacterDetailBuilder {
    
    static func build(for coordinator: Navigating, container: DIContainer.Type = DIContainer.self, characterID: Int?) -> UIViewController {
        guard let id = characterID else { return PlaceholderDetailViewController() }

        let viewController = CharacterDetailViewController()
        let interactor = CharacterDetailInteractor(characterID: id)
        let presenter = CharacterDetailPresenter()
        let router = CharacterDetailRouter()
        let worker = CharacterDetailWorker(container: container)

        viewController.interactor = interactor
        viewController.router = router

        interactor.worker = worker
        interactor.presenter = presenter
        
        router.viewController = viewController
        router.coordinator = coordinator
        
        presenter.viewController = viewController

        return viewController
    }
}

//
//  CharacterListBuilder.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import UIKit


enum CharacterListBuilder {
    
    static func build(for coordinator: Navigating, container: DIContainer.Type = DIContainer.self) -> UIViewController {
        let viewController = CharacterListViewController()
        let interactor = CharacterListInteractor()
        let presenter = CharacterListPresenter()
        let router = CharacterListRouter()
        let worker = CharacterListWorker(container: container)

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

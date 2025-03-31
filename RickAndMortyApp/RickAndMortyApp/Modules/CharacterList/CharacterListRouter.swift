//
//  CharacterListRouter.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import UIKit


protocol CharacterListRoutingLogic {
    
    var coordinator: Navigating? { get set }
    
    func routeToDetail(for characterID: Int)
    
    func showError(errorData: AlertData)
}

final class CharacterListRouter: CharacterListRoutingLogic {
    
    // MARK: -
    // MARK: Variables
    
    weak var viewController: UIViewController?
    var coordinator: Navigating?
    
    // MARK: -
    // MARK: Character List Routing Logic

    func routeToDetail(for characterID: Int) {
        self.coordinator?.navigateTo(.characterDetails(characterID))
    }
    
    func showError(errorData: AlertData) {
        self.coordinator?.navigateTo(.modal(errorData), from: self.viewController)
    }
}

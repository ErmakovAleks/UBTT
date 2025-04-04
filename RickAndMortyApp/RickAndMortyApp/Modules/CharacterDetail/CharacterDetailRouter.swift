//
//  CharacterDetailRouter.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import UIKit


protocol CharacterDetailRoutingLogic {
    
    var coordinator: Navigating? { get set }
    
    func showError(errorData: AlertData)
}

final class CharacterDetailRouter: CharacterDetailRoutingLogic {
    
    // MARK: -
    // MARK: Variables
    
    weak var viewController: UIViewController?
    var coordinator: Navigating?
    
    // MARK: -
    // MARK: Character Detail Routing Logic
    
    func showError(errorData: AlertData) {
        self.coordinator?.navigateTo(.modal(errorData), from: self.viewController)
    }
}

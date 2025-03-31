//
//  AppCoordinator.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import UIKit


enum DeviceType {
    
    case iPhone
    case iPad

    static var current: DeviceType {
        UIDevice.current.userInterfaceIdiom == .pad ? .iPad : .iPhone
    }
}

struct AlertData {
    
    let title: String
    let message: String
}

enum AppScreen {
    
    case characterList
    case characterDetails(Int)
    case modal(AlertData)
}

protocol Navigating {
    
    func navigateTo(_ screen: AppScreen, from source: UIViewController?)
}

extension Navigating {
    
    func navigateTo(_ screen: AppScreen) {
        self.navigateTo(screen, from: nil)
    }
}

final class AppCoordinator: Navigating {
    
    // MARK: -
    // MARK: Variables
    
    let deviceType: DeviceType

    private var navigationController: UINavigationController?
    private var splitViewController: UISplitViewController?
    
    // MARK: -
    // MARK: Initialization

    init() {
        self.deviceType = DeviceType.current
    }
    
    // MARK: -
    // MARK: Public Functions

    func start(window: UIWindow) {
        let viewController = CharacterListBuilder.build(for: self)
        
        switch deviceType {
        case .iPhone:
            let nav = UINavigationController()
            self.navigationController = nav
            nav.viewControllers = [viewController]
            window.rootViewController = nav
        case .iPad:
            let splitVC = UISplitViewController(style: .doubleColumn)
            splitVC.preferredDisplayMode = .oneBesideSecondary
            splitVC.preferredSplitBehavior = .tile
            
            self.splitViewController = splitVC

            let placeholder = PlaceholderDetailViewController()

            splitVC.setViewController(viewController, for: .primary)
            splitVC.setViewController(placeholder, for: .secondary)

            window.rootViewController = splitVC
        }

        window.makeKeyAndVisible()
    }
    
    // MARK: -
    // MARK: Navigating Protocol
    
    func navigateTo(_ screen: AppScreen, from source: UIViewController? = nil) {
        switch screen {
        case .characterList:
            let viewController = UIViewController()
            self.showScreen(viewController: viewController)
        case .characterDetails(let id):
            let viewController = CharacterDetailBuilder.build(for: self, characterID: id)
            self.showScreen(viewController: viewController)
        case .modal(let alertData):
            let alert = UIAlertController(title: alertData.title, message: alertData.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            source?.present(alert, animated: true)
        }
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func presentAsSheet(_ viewController: UIViewController, from source: UIViewController?) {
        let presentingVC = source ?? navigationController?.visibleViewController ?? splitViewController
        viewController.modalPresentationStyle = deviceType == .iPad ? .formSheet : .automatic
        presentingVC?.present(viewController, animated: true)
    }
    
    private func showScreen(viewController: UIViewController, from source: UIViewController? = nil) {
        if let source {
            self.presentAsSheet(viewController, from: source)
        } else {
            switch self.deviceType {
            case .iPhone:
                self.navigationController?.pushViewController(viewController, animated: true)
            case .iPad:
                self.splitViewController?.setViewController(viewController, for: .secondary)
            }
        }
    }
}

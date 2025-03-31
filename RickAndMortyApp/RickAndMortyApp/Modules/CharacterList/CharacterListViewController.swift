//
//  CharacterListViewController.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import UIKit


final class CharacterListViewController: UIViewController {
    
    // MARK: -
    // MARK: Variables
    
    var interactor: CharacterListInteractorProtocol?
    var router: CharacterListRoutingLogic?
    
    private var tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, CharacterList.Fetch.ViewModel.DisplayedCharacter>?

    // MARK: -
    // MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.interactor?.fetchCharacters(request: .init())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: -
    // MARK: Public Functions
    
    func displayCharacters(viewModel: CharacterList.Fetch.ViewModel) {
        var snapshot = self.dataSource?.snapshot() ?? NSDiffableDataSourceSnapshot<Int, CharacterList.Fetch.ViewModel.DisplayedCharacter>()
        
        if snapshot.numberOfItems == 0 {
            snapshot.appendSections([0])
        }
        
        snapshot.appendItems(viewModel.displayedCharacters)
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func displayError(viewModel: CharacterDetail.Error.ViewModel) {
        self.router?.showError(errorData: .init(title: "Error", message: viewModel.message))
    }
    
    // MARK: -
    // MARK: Private Functions
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = .systemPurple.withAlphaComponent(0.9)
        self.tableView.register(CharacterCell.self, forCellReuseIdentifier: String(describing: CharacterCell.self))
        
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        self.dataSource = UITableViewDiffableDataSource<Int, CharacterList.Fetch.ViewModel.DisplayedCharacter>(tableView: self.tableView) {
            tableView, indexPath, character in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: CharacterCell.self),
                for: indexPath
            ) as? CharacterCell else { return UITableViewCell() }
            
            cell.configure(with: character)
            
            return cell
        }
    }
}

extension CharacterListViewController: UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let character = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        self.router?.routeToDetail(for: character.id)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.height
        
        if offsetY > contentHeight - visibleHeight - 100 {
            self.interactor?.requestNextPage()
        }
    }
}

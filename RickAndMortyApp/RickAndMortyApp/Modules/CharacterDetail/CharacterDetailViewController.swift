//
//  CharacterDetailViewController.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import UIKit


final class CharacterDetailViewController: UIViewController {

    var interactor: CharacterDetailInteractorProtocol?
    var router: CharacterDetailRoutingLogic?

    private let cardView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    private let originLabel = UILabel()
    private let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6
        self.setupLayout()
        self.interactor?.fetchCharacter(request: .init())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func displayCharacter(viewModel: CharacterDetail.Show.ViewModel) {
            self.nameLabel.text = viewModel.name
            self.genderLabel.text = "Gender: \(viewModel.gender)"
            self.originLabel.text = "Origin: \(viewModel.origin)"
            self.statusLabel.text = "Status: \(viewModel.status)"
            self.imageView.setImage(from: viewModel.imageURL)
    }

    private func setupLayout() {
        self.cardView.backgroundColor = UIColor.systemPink
        self.cardView.layer.cornerRadius = 16
        self.cardView.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 12
        self.imageView.backgroundColor = .cyan
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.font = .preferredFont(forTextStyle: .title1)
        self.nameLabel.textAlignment = .center
        
        self.nameLabel.font = .boldSystemFont(ofSize: 20)
        self.genderLabel.font = .systemFont(ofSize: 16)
        self.originLabel.font = .systemFont(ofSize: 16)
        self.statusLabel.font = .systemFont(ofSize: 16)
        
        [self.nameLabel, self.genderLabel, self.originLabel, self.statusLabel].forEach {
            $0.textColor = .white
            $0.numberOfLines = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let textStack = UIStackView(
            arrangedSubviews: [
                self.nameLabel,
                self.genderLabel,
                self.originLabel,
                self.statusLabel
            ]
        )
        
        textStack.axis = .vertical
        textStack.spacing = 8
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.cardView.addSubview(self.imageView)
        self.cardView.addSubview(textStack)
        self.view.addSubview(self.cardView)

        NSLayoutConstraint.activate([
            self.cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            self.cardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            self.cardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.imageView.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 16),
            self.imageView.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 16),
            self.imageView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -16),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor),
            
            textStack.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 16),
            textStack.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -16),
            textStack.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -16)
        ])
    }
}

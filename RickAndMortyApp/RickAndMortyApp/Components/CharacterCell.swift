//
//  CharacterCell.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 31.03.2025.
//

import UIKit


final class CharacterCell: UITableViewCell {
    
    // MARK: -
    // MARK: Variables

    private let container = UIView()
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    private let originLabel = UILabel()
    
    // MARK: -
    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: -
    // MARK: Public Functions
    
    func configure(with character: CharacterList.Fetch.ViewModel.DisplayedCharacter) {
        self.nameLabel.text = character.name
        self.genderLabel.text = "Gender: \(character.gender)"
        self.originLabel.text = "Origin: \(character.origin)"
    }
    
    // MARK: -
    // MARK: Private Functions

    private func setupLayout() {
        self.backgroundColor = .systemPurple.withAlphaComponent(0.7)
        self.selectionStyle = .none
        
        self.container.translatesAutoresizingMaskIntoConstraints = false
        self.container.backgroundColor = .white
        self.container.layer.cornerRadius = 12
        self.container.clipsToBounds = true
        
        self.nameLabel.font = .boldSystemFont(ofSize: 18)
        self.nameLabel.textColor = .black
        
        self.genderLabel.font = .systemFont(ofSize: 14)
        self.genderLabel.textColor = .gray
        
        self.originLabel.font = .systemFont(ofSize: 14)
        self.originLabel.textColor = .gray
        
        let stack = UIStackView(arrangedSubviews: [self.nameLabel, self.genderLabel, self.originLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        self.container.addSubview(stack)
        self.contentView.addSubview(self.container)

        NSLayoutConstraint.activate([
            self.container.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            self.container.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.container.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            stack.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: -16)
        ])
    }
}

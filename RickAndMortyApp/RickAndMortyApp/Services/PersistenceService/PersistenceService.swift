//
//  PersistenceService.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

protocol PersistenceServiceProtocol {
    
    static var shared: Self { get }
    
    func loadCharacters() -> [Character_]
    
    func loadCharacter(by id: Int) -> Character_?
}

final class PersistenceService: PersistenceServiceProtocol {
    
    // MARK: -
    // MARK: Variables
    
    static let shared = PersistenceService()
    
    // MARK: -
    // MARK: Initialization
    
    private init() { }
    
    // MARK: -
    // MARK: Persistence Service Protocol
    
    func loadCharacters() -> [Character_] {
        return []
    }
    
    func loadCharacter(by id: Int) -> Character_? {
        return nil
    }
}

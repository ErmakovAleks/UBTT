//
//  CharacterListModels.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import Foundation


struct CharactersParams: URLContainable {

    typealias DecodableType = CharacterItemsList
    
    var path: String = "/api/character/"
    var header: [String : String]?
    var body: [String : Any]?
    
    init(page: Int = 0) {
        self.header = ["page" : "\(page)"]
    }
}

struct CharacterItemsList: Codable {
    
    let info: Info
    let results: [Character_]
}

struct Info: Codable {
    
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?
}

struct Character_: Codable {
    
    let id: Int
    let name: String
    let status: CharacterStatus
    let type: String
    let gender: Gender
    let origin: Origin
    let location: Location_
    let image: String
    let url: String
}

enum CharacterStatus: String, Codable {
    
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

enum Gender: String, Codable {
    
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
}

struct Origin: Codable {
    
    let name: String
    let url: String
}

struct Location_: Codable {
    
    let name: String
    let url: String
}

enum CharacterList {
    
    enum Fetch {
        
        struct Request {}
        
        struct Response {
            
            let characters: [Character_]
        }

        struct ViewModel {
            
            struct DisplayedCharacter: Hashable {
                
                let id: Int
                let name: String
                let gender: String
                let origin: String
                let imageURL: URL?
                
                func hash(into hasher: inout Hasher) {
                    hasher.combine(id)
                }
                
                static func ==(lhs: Self, rhs: Self) -> Bool {
                    lhs.id == rhs.id
                }
            }

            let displayedCharacters: [DisplayedCharacter]
        }
    }
}

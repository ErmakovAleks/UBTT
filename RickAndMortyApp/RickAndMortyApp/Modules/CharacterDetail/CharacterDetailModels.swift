//
//  CharacterDetailModels.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import Foundation


struct CharacterParams: URLContainable {

    typealias DecodableType = Character_
    
    var path: String = "/api/character/"
    var header: [String : String]?
    var body: [String : Any]?
    
    init(id: Int = 0) {
        self.path = "\(path)\(id)"
    }
}

enum CharacterDetail {
    
    enum Show {
        
        struct Request {}

        struct Response {
            
            let character: Character_
        }

        struct ViewModel {
            
            let name: String
            let gender: String
            let origin: String
            let status: String
            let imageURL: String
        }
    }
    
    enum Error {
        
            struct Response { let error: RequestError }
            struct ViewModel { let message: String }
        }
}

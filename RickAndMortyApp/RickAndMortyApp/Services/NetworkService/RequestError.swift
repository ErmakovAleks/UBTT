//
//  RequestError.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import Foundation

enum RequestError: LocalizedError {
    
    case decode
    case failure(Error)
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode(String)
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .decode:
            return "<!> Decode error"
        case .invalidURL:
            return "<!> URL is incorrect"
        case .noResponse:
            return "<!> There is no response from server"
        case .unauthorized:
            return "<!> Session expired"
        case .unexpectedStatusCode(let url):
            return "<!> Unexpected status code: \(url)"
        case .unknown(let url):
            return "<!> Unknown error = \(url)"
        case  .failure(let error):
            return error.localizedDescription
        }
    }
}

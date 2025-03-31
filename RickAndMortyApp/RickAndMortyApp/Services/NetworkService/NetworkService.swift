//
//  NetworkService.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import Foundation

typealias ResultCompletion<T> = (Result<T, RequestError>) -> ()

protocol URLContainable {
    
    associatedtype DecodableType: Decodable
    
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get set }
    var body: [String: Any]? { get set }
}

extension URLContainable {
    
    var scheme: String {
        "https"
    }
    
    var host: String {
        "rickandmortyapi.com"
    }
    
    var method: HTTPMethod {
        .get
    }
}

protocol NetworkSessionProtocol {
    
    static var shared: Self { get }

    func sendRequest<T: URLContainable>(
        requestModel: T,
        completion: @escaping ResultCompletion<T.DecodableType>
    )
    
    func sendDataRequest<T: URLContainable>(
        requestModel: T,
        completion: @escaping ResultCompletion<Data>
    )
}

final class NetworkService: NetworkSessionProtocol {
    
    // MARK: -
    // MARK: Variables
    
    static let shared = NetworkService()
    
    // MARK: -
    // MARK: Initialization
    
    private init() { }
    
    // MARK: -
    // MARK: Network Service Protocol
    
    func sendRequest<T: URLContainable>(
        requestModel: T,
        completion: @escaping ResultCompletion<T.DecodableType>
    ) {
        guard let request = self.configureRequest(requestModel: requestModel) else { return }
        self.processTask(request: request, requestModel: requestModel, completion: completion)
    }
    
    func sendDataRequest<T: URLContainable>(
        requestModel: T,
        completion: @escaping ResultCompletion<Data>
    ) {
        guard let request = self.configureRequest(requestModel: requestModel) else { return }
        self.processTask(request: request, completion: completion)
    }
    
    func sendDataRequest(
        url: URL,
        completion: @escaping ResultCompletion<Data>
    ) {
        let request = URLRequest(url: url)
        self.processTask(request: request, completion: completion)
    }
    
    func sendRequest<T: Decodable>(
        url: URL,
        decodableType: T.Type,
        completion: @escaping ResultCompletion<T>
    ) {
        let request = URLRequest(url: url)
        self.processTask(request: request, completion: completion)
    }
    
    // MARK: -
    // MARK: Private Functions
    
    private func configureRequest<T: URLContainable>(
        requestModel: T
    ) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = requestModel.scheme
        urlComponents.host = requestModel.host
        urlComponents.path = requestModel.path
        
        if let headers = requestModel.header {
            urlComponents.queryItems = headers.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            debugPrint("<!> URL is incorrected!")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestModel.method.rawValue
        request.allHTTPHeaderFields = requestModel.header
        
        if let body = requestModel.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        }
        
        return request
    }
    
    private func processTask<T: URLContainable>(
        request: URLRequest,
        requestModel: T,
        completion: @escaping ResultCompletion<T.DecodableType>
    ) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(RequestError.failure(error)))
                }
            }
            
            if let response = response as? HTTPURLResponse {
                let handleResult: Result<T.DecodableType, RequestError>
                
                switch response.statusCode {
                case 200..<300:
                    if let data = data,
                       let results = try? JSONDecoder().decode(T.DecodableType.self , from: data) {
                        handleResult = .success(results)
                    } else {
                        handleResult = .failure(.decode)
                    }
                case 401:
                    handleResult = .failure(.unauthorized)
                default:
                    handleResult = .failure(.unexpectedStatusCode(request.url?.description ?? ""))
                }
                
                DispatchQueue.main.async {
                    completion(handleResult)
                }
            }
        }
        
        task.resume()
    }
    
    private func processTask<T: Decodable>(
        request: URLRequest,
        completion: @escaping ResultCompletion<T>
    ) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(RequestError.failure(error)))
                }
            }
            
            if let response = response as? HTTPURLResponse {
                let handleResult: Result<T, RequestError>
                
                switch response.statusCode {
                case 200..<300:
                    if let data = data,
                       let results = try? JSONDecoder().decode(T.self , from: data) {
                        handleResult = .success(results)
                    } else {
                        handleResult = .failure(.decode)
                    }
                case 401:
                    handleResult = .failure(.unauthorized)
                default:
                    handleResult = .failure(.unexpectedStatusCode(request.url?.description ?? ""))
                }
                
                DispatchQueue.main.async {
                    completion(handleResult)
                }
            }
        }
        
        task.resume()
    }
    
    private func processTask(
        request: URLRequest,
        completion: @escaping ResultCompletion<Data>
    ) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(.failure(RequestError.unknown(request.url?.description ?? "")))
                }
            }
            if let response = response as? HTTPURLResponse {
                let handleResult: Result<Data, RequestError>
                
                switch response.statusCode {
                case 200..<300:
                    if let data = data {
                        handleResult = .success(data)
                    } else {
                        handleResult = .failure(.unknown("<!> No data returned"))
                    }
                case 401:
                    handleResult = .failure(.unauthorized)
                default:
                    handleResult = .failure(RequestError.unexpectedStatusCode(request.url?.description ?? ""))
                }
                
                DispatchQueue.main.async {
                    completion(handleResult)
                }
            }
        }
        
        task.resume()
    }
}

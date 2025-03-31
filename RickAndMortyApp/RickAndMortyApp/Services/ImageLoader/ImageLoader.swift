//
//  ImageLoader.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import UIKit


protocol ImageLoaderProtocol {
    
    static var shared: Self { get }
    
    func load(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

final class ImageLoader: ImageLoaderProtocol {
    
    // MARK: -
    // MARK: Variables
    
    static let shared = ImageLoader()

    private var runningTasks: [String: [((UIImage?) -> Void)]] = [:]
    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "ImageLoaderQueue", attributes: .concurrent)
    
    // MARK: -
    // MARK: Initialization

    private init() {}

    func load(from url: String, completion: @escaping (UIImage?) -> Void) {
        if let cached = self.cache.object(forKey: url as NSString) {
            DispatchQueue.main.async {
                completion(cached)
            }
            
            return
        }

        self.queue.sync(flags: .barrier) {
            if self.runningTasks[url] != nil {
                self.runningTasks[url]?.append(completion)
                
                return
            } else {
                self.runningTasks[url] = [completion]
            }
        }

        guard let gUrl = URL(string: url) else {
            self.completeAll(for: url, image: nil)
            
            return
        }

        URLSession.shared.dataTask(with: gUrl) { [weak self] data, _, _ in
            guard let self = self else { return }
            var image: UIImage?

            if let data = data {
                image = UIImage(data: data)
                if let image = image {
                    self.cache.setObject(image, forKey: url as NSString)
                }
            }

            self.completeAll(for: url, image: image)
        }.resume()
    }

    private func completeAll(for urlString: String, image: UIImage?) {
        self.queue.async(flags: .barrier) {
            let completions = self.runningTasks[urlString] ?? []
            self.runningTasks.removeValue(forKey: urlString)

            DispatchQueue.main.async {
                completions.forEach { $0(image) }
            }
        }
    }
}

//
//  UIImageView+Extensions.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import UIKit


private var activityIndicatorKey: UInt8 = 0

extension UIImageView {
    
    private var spinner: UIActivityIndicatorView {
        if let existing = objc_getAssociatedObject(self, &activityIndicatorKey) as? UIActivityIndicatorView {
            return existing
        }
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .black
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        objc_setAssociatedObject(self, &activityIndicatorKey, spinner, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return spinner
    }
    
    func setImage(
        from url: String,
        placeholder: UIImage? = nil,
        loader: ImageLoaderProtocol = ImageLoader.shared
    ) {
        DispatchQueue.main.async {
            self.image = placeholder
            self.spinner.startAnimating()
        }
        
        loader.load(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.image = image ?? placeholder
            }
        }
    }
}

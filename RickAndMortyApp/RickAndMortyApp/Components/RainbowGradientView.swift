//
//  RainbowGradientView.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import UIKit

final class RainbowGradientView: UIView {
    
    // MARK: -
    // MARK: Variables
    
    private var gradientLayer: CAGradientLayer? {
        return self.layer as? CAGradientLayer
    }
    
    // MARK: -
    // MARK: Overrided
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    // MARK: -
    // MARK: View Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.applyRainbowGradient()
    }
    
    // MARK: -
    // MARK: Private Functions

    private func applyRainbowGradient() {
        self.gradientLayer?.type = .conic
        self.gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0.5)
        self.gradientLayer?.endPoint = CGPoint(x: 1, y: 1)
        self.gradientLayer?.colors = [
            UIColor.red.cgColor,
            UIColor.orange.cgColor,
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.cyan.cgColor,
            UIColor.blue.cgColor,
            UIColor.purple.cgColor,
            UIColor.red.cgColor
        ]
        
        self.gradientLayer?.locations = stride(from: 0, through: 1, by: 1.0 / 7.0).map { NSNumber(value: Float($0)) }
    }
}

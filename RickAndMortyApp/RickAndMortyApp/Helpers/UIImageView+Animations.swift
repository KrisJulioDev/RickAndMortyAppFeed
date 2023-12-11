//
//  UIImageView+Animations.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/11/23.
//

import UIKit

extension UIImageView {
    func setAnimated(_ newImage: UIImage?) {
        image = newImage
        
        guard newImage != nil else { return }
        
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}


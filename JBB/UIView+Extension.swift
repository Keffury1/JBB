//
//  UIView+Extension.swift
//  JBB
//
//  Created by Bobby Keffury on 8/31/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 6.0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.25
    }
    
    func addGradient(color: CGColor) {
        let gradient = CAGradientLayer()

        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor, color]

        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        self.layer.insertSublayer(gradient, at: 0)
        self.clipsToBounds = true
    }
    
    func addRounding() {
        self.layer.cornerRadius = 10.0
    }
}


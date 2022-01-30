//
//  UIView+Extension.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/4/21.
//

import Foundation
import UIKit

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0.0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }
    
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    func addTopDownGradient(color: CGColor) {
        let gradient = CAGradientLayer()

        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor, color]

        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        self.layer.insertSublayer(gradient, at: 0)
        self.clipsToBounds = true
    }
}

extension UIImageView {
    func heartbeatAnimation() {
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.12
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.75
        animationGroup.repeatCount = 1000
        animationGroup.animations = [pulse1]

        self.layer.add(animationGroup, forKey: "pulse")
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

//
//  UIView+Extension.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/4/21.
//

import Foundation
import UIKit

extension UIView {
    func addShadowAndRadius() {
        self.layer.cornerRadius = 10.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0.0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }
}

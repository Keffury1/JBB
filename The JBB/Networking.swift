//
//  Networking.swift
//  JBB
//
//  Created by Bobby Keffury on 12/16/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case badData
    case otherError
    case noDecode
}

class Networking {
    
    static let shared = Networking()
    var bannerAd = "ca-app-pub-9585815002804979/7202756884"
    var testAd = "ca-app-pub-3940256099942544/6300978111"
}



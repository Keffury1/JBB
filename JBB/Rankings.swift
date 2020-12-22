//
//  Rankings.swift
//  JBB
//
//  Created by Bobby Keffury on 12/22/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import UIKit

struct Rankings: Codable {
    var division1: [Team]
    var division2: [Team]
    var division3: [Team]
    var CCCAA: [Team]
}

struct Team: Codable {
    var roster: [Player?]
    var name: String
    var logo: String
}

struct Player: Codable {
    var name: String
    var number: String
    var position: String
    var attributes: [String]
}

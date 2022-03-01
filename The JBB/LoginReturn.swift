//
//  LoginReturn.swift
//  The JBB
//
//  Created by Bobby Keffury on 2/5/22.
//

import Foundation

struct LoginReturn: Codable {
    let data: JWT
}

struct JWT: Codable {
    let jwt: String
}

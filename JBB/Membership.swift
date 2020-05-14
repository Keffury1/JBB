//
//  Membership.swift
//  JBB
//
//  Created by Bobby Keffury on 5/13/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

class Membership {
    
    var year: String
    var price: String
    var archived: String
    var premium: String
    var adFree: String
    var annualSubscription: String?
    
    init(year: String, price: String, archived: String, premium: String, adFree: String, annualSubscription: String?) {
        self.year = year
        self.price = price
        self.archived = archived
        self.premium = premium
        self.adFree = adFree
        self.annualSubscription = annualSubscription
    }
}

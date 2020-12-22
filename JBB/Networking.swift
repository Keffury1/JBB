//
//  Networking.swift
//  JBB
//
//  Created by Bobby Keffury on 12/16/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import UIKit

class Networking {
    
    var ranking: Rankings?
    let teams: [Team] = []
    
    // MARK: - URLs
    
    private let rankingsUrl = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/1pJtjTboz3dwJ_Efk6J6-KUTO3Yc9tqIoIaAU_O-ALOY/values/Sheet1!A1:D5")!
    
    private let teamsUrl = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/1PphxiB4gAPneGkfgYloM-K4EQtapL1GFETSKw0xMGEY/values/Sheet1!A1:D5")!
    
    func fetchRankings() {
        var request = URLRequest(url: rankingsUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let _ = error {
                print(String(describing: error))
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let rankings = try decoder.decode(Rankings.self, from: data)
                self.ranking = rankings
            } catch {
                print("Error decoding rankings: \(error)")
                return
            }
        }.resume()
    }
}



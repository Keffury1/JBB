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
    
    static let shared = Networking()
    var teams: [Player] = []
    
    // MARK: - URLs
    
    private let rankingsUrl = URL(string: "https://sheetdb.io/api/v1/zpcfljmndw1hh")!
    
    private let teamsUrl = URL(string: "https://sheetdb.io/api/v1/af61ce4gn2ps4")!
    
    func fetchRankings(completion: @escaping (Result<[Ranking], Error>) -> Void) {
        var request = URLRequest(url: rankingsUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print(String(describing: error))
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let rankings = try decoder.decode([Ranking].self, from: data)
                completion(.success(rankings))
            } catch {
                print("Error decoding rankings: \(error)")
                completion(.failure(error))
                return
            }
        }.resume()
    }
    
    func fetchTeams(completion: @escaping (Result<[Player], Error>) -> Void) {
        var request = URLRequest(url: teamsUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print(String(describing: error))
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let teams = try decoder.decode([Player].self, from: data)
                completion(.success(teams))
            } catch {
                print("Error decoding rankings: \(error)")
                completion(.failure(error))
                return
            }
        }.resume()
    }
    
    func sortPlayersByTeam() -> [[Player]] {
        var league: [[Player]] = [[]]
        
        var previous: String? = nil
        
        for player in teams {
            let first = player.school
            
            if first != previous {
                league.append([])
                previous = first
            }
            league[league.endIndex - 1].append(player)
        }
        return league
    }
}



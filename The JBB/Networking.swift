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
    var ranking: [Ranking] = []
    var teams: [Player] = []
    
    // MARK: - URLs
    
    private let rankingsUrl = URL(string: "https://sheetdb.io/api/v1/zpcfljmndw1hh")!
    
    private let teamsUrl = URL(string: "https://sheetdb.io/api/v1/af61ce4gn2ps4")!
    
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
                let rankings = try decoder.decode([Ranking].self, from: data)
                self.ranking = rankings
            } catch {
                print("Error decoding rankings: \(error)")
                return
            }
        }.resume()
    }
    
    func fetchTeams() {
        var request = URLRequest(url: teamsUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let _ = error {
                print(String(describing: error))
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let teams = try decoder.decode([Player].self, from: data)
                self.teams = teams
            } catch {
                print("Error decoding rankings: \(error)")
                return
            }
        }.resume()
    }
    
    func sortTeamsByDivision() -> [[Ranking]] {
        var rankings: [[Ranking]] = [[]]
        
        var previous: String? = nil
        
        for team in ranking {
            let first = team.Division
            
            if first != previous {
                rankings.append([])
                previous = first
            }
            rankings[rankings.endIndex - 1].append(team)
        }
        return rankings
    }
    
    func sortPlayersByTeam() -> [[Player]] {
        var league: [[Player]] = [[]]
        
        var previous: String? = nil
        
        for player in teams {
            let first = player.School
            
            if first != previous {
                league.append([])
                previous = first
            }
            league[league.endIndex - 1].append(player)
        }
        return league
    }
}



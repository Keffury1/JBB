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

protocol RankingsFilledDelegate {
    func rankingsWereFilled(list: [[Ranking]])
    
    func teamsWereFilled()
}

class Networking {
    
    static let shared = Networking()
    
    var rankingsDelegate: RankingsFilledDelegate?
    
    var rankingList: [[Ranking]]? {
        didSet {
            rankingsDelegate?.rankingsWereFilled(list: self.rankingList!)
        }
    }
    var playerList: [[Player]]? {
        didSet {
            rankingsDelegate?.teamsWereFilled()
        }
    }
    
    // MARK: - URLs
    
    private let rankingsUrl = URL(string: "https://sheetdb.io/api/v1/oxdzti3x7zh7c")!
    
    private let teamsUrl = URL(string: "https://sheetdb.io/api/v1/9oqa36i1lo6wg")!
    
    func fetchRankings(completion: @escaping (Result<[[Ranking]], Error>) -> Void) {
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
                let rankingsList = self.sortTeamsByDivision(from: rankings)
                completion(.success(rankingsList))
            } catch {
                print("Error decoding rankings: \(error)")
                completion(.failure(error))
                return
            }
        }.resume()
    }
    
    func fetchTeams(completion: @escaping (Result<[[Player]], Error>) -> Void) {
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
                let players = self.sortPlayersByTeam(from: teams)
                completion(.success(players))
            } catch {
                print("Error decoding rankings: \(error)")
                completion(.failure(error))
                return
            }
        }.resume()
    }
    
    func sortPlayersByTeam(from players: [Player]) -> [[Player]] {
        var league: [[Player]] = [[]]
        
        var previous: String? = nil
        
        for player in players {
            let first = player.school
            
            if first != previous {
                league.append([])
                previous = first
            }
            league[league.endIndex - 1].append(player)
        }
        return league
    }
    
    func sortTeamsByDivision(from teams: [Ranking]) -> [[Ranking]] {
        var rankings: [[Ranking]] = [[]]
        
        var previous: String? = nil
        
        for team in teams {
            let first = team.Division
            
            if first != previous {
                rankings.append([])
                previous = first
            }
            rankings[rankings.endIndex - 1].append(team)
        }
        return rankings
    }
    
    func fetchImage(at urlString: String?, completion: @escaping (_ data: Data?) -> ()) {
        guard let string = urlString else { return }
        let imageUrl = URL(string: string)!
        
        var request = URLRequest(url: imageUrl)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let _ = error {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            completion(data)
        }.resume()
    }
}



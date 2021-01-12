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
    func rankingsWereFilled(list: [[Player]])
}

class Networking {
    
    static let shared = Networking()
    
    var rankingsDelegate: RankingsFilledDelegate?
    
    var rankingList: [[Player]]? {
        didSet {
            rankingsDelegate?.rankingsWereFilled(list: self.rankingList!)
        }
    }
    var playerList: [[Player]]?
    
    // MARK: - URLs
    
    private let teamsUrl = URL(string: "https://sheetdb.io/api/v1/9oqa36i1lo6wg")!
    
    
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
                self.rankingList = self.sortTeamsByRank(from: teams)
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
    
    func sortTeamsByRank(from players: [Player]) -> [[Player]]? {
        var teams: [[Player]] = [[]]
        var previous: String? = nil
        
        for player in players {
            let first = player.rank
            
            if first == "" {
                continue
            } else {
                if first != previous {
                    teams.append([])
                    previous = first
                }
                teams[teams.endIndex - 1].append(player)
            }
        }
        
        teams.sort { (team1, team2) -> Bool in
            Int(team1.first!.rank)! > Int(team2.first!.rank)!
        }
        
        return teams
    }
    
    func sortTeamsByDivision(from teams: [Player]) -> [[Player]] {
        var players: [[Player]] = [[]]
        
        var previous: String? = nil
        
        for team in teams {
            let first = team.division
            
            if first != previous {
                players.append([])
                previous = first
            }
            players[players.endIndex - 1].append(team)
        }
        return players
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



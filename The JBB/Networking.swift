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
    
    var started: Bool? = true
    
    var rankingsDelegate: RankingsFilledDelegate?
    
    var rankingList: [[Player]]? {
        didSet {
            rankingsDelegate?.rankingsWereFilled(list: self.rankingList!)
            started = false
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
                self.rankingList = self.getRankedTeams(from: players)
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
    
    func getRankedTeams(from teams: [[Player]]) -> [[Player]] {
        var rankedTeams: [[Player]] = [[]]
        
        for team in teams {
            if team.first?.rank != "" {
                rankedTeams.append(team)
            } else {
                continue
            }
        }
        
        return rankedTeams
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



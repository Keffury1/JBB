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
    
    func teamsWereFilled()
}

class ImageLoader {
    
    // MARK: - Properties
    
    static let shared = ImageLoader()
    
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    func fetchImage(at urlString: String?, _ completion: @escaping (Result<UIImage, Error>) -> (Void)) -> UUID? {
        guard let string = urlString else { return nil }
        guard let imageUrl = URL(string: string) else { return nil}
        
        if let image = loadedImages[imageUrl] {
            completion(.success(image))
            return nil
        }
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            
            defer{self.runningRequests.removeValue(forKey: uuid)}
            
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages[imageUrl] = image
                completion(.success(image))
                return
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
        }
        
        task.resume()
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }
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
    var playerList: [[Player]]? {
        didSet {
            rankingsDelegate?.teamsWereFilled()
        }
    }
    
    // MARK: - URLs
    
    private let teamsUrl = URL(string: "https://sheetdb.io/api/v1/9oqa36i1lo6wg")!

    func fetchTeams(completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: teamsUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print(String(describing: error))
                completion(error)
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let teams = try decoder.decode([Player].self, from: data)
                let players = self.sortPlayersByTeam(from: teams)
                self.playerList = players
                self.rankingList = self.getRankedTeams(from: players)
                completion(nil)
            } catch {
                print("Error decoding rankings: \(error)")
                completion(error)
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
}



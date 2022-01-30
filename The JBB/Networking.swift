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
    let baseURL = "https://thejbb.net/wp-json/wp/v2"
    var bannerAd = "ca-app-pub-9585815002804979/7202756884"
    var testAd = "ca-app-pub-3940256099942544/6300978111"
    
    func getPostURL(offset: Int?) -> URL? {
        let queryItems = [URLQueryItem(name: "per_page", value: "25"), URLQueryItem(name: "offset", value: "\(offset ?? 0)")]
        var urlComps = URLComponents(string: baseURL + "/posts")!
        urlComps.queryItems = queryItems
        return urlComps.url
    }
    
    func getAllPosts(offset: Int?, onSuccess: @escaping(_ posts: [Post]) -> Void, onError: @escaping(_ errorMessage: String?) -> Void) {
        guard let url = getPostURL(offset: offset) else {
            onError("Bad URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let _ = error {
                onError(error.debugDescription)
                return
            }
            
            guard let data = data else {
                onError("Bad Data")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let posts = try decoder.decode([Post].self, from: data)
                onSuccess(posts)
            } catch {
                onError("Error Decoding Posts: \(error)")
                return
            }
        }.resume()
    }
}

//
//  PostController.swift
//  JBB
//
//  Created by Bobby Keffury on 5/26/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

class PostController {
    
    var badData = 9999
    
    func fetchPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        let url = URL(string: "https://thejbb.net/wp-json/wp/v2/posts/?per_page=100")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error fetching posts: \(error)")
                completion(nil, error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completion(nil, NSError(domain: "Fetching Posts", code: response.statusCode, userInfo: nil))
                    return
                }
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "Fetching Posts", code: self.badData, userInfo: nil))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let posts = try decoder.decode([Post].self, from: data)
                completion(posts, nil)
            } catch {
                print("Error decoding posts: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
}

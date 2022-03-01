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
    let authURL = "https://thejbb.net/?rest_route=/simple-jwt-login/v1/auth"
    var bannerAd = "ca-app-pub-9585815002804979/7202756884"
    var testAd = "ca-app-pub-3940256099942544/6300978111"
    
    func login(username: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String?) -> Void) {

        let data = "&username=\(username)&password=\(password)"
        let url = URL(string: authURL + data)!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                onError("Bad Data")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let token = try decoder.decode(LoginReturn.self, from: data)
                globalToken = token.data.jwt
                onSuccess()
            } catch {
                onError("Error Logging In User: \(error)")
                return
            }
        }.resume()
    }
    
    func getPostURL(offset: Int?, searchTerm: String?) -> URL? {
        let queryItems = [URLQueryItem(name: "per_page", value: "15"), URLQueryItem(name: "offset", value: "\(offset ?? 0)"), URLQueryItem(name: "search", value: "\(searchTerm ?? "")")]
        var urlComps = URLComponents(string: baseURL + "/posts")!
        urlComps.queryItems = queryItems
        var url: URL?
        if let string = urlComps.string {
            guard let token = globalToken else { return nil }
            url = URL(string: string + "&JWT=\(token)")
        }
        return url
    }
    
    func getAllPosts(offset: Int?, searchTerm: String?, onSuccess: @escaping(_ posts: [Post]) -> Void, onError: @escaping(_ errorMessage: String?) -> Void) {
        guard let url = getPostURL(offset: offset, searchTerm: searchTerm) else {
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
    
    func getCategoriesURL() -> URL? {
        let queryItems = [URLQueryItem(name: "per_page", value: "50")]
        var urlComps = URLComponents(string: baseURL + "/categories")!
        urlComps.queryItems = queryItems
        return urlComps.url
    }
    
    func getAllCategories(onSuccess: @escaping(_ categories: [Category]) -> Void, onError: @escaping(_ errorMessage: String?) -> Void) {
        guard let url = getCategoriesURL() else {
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
                let categories = try decoder.decode([Category].self, from: data)
                onSuccess(categories)
            } catch {
                onError("Error Decoding Posts: \(error)")
                return
            }
        }.resume()
    }
}

//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 07/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { } /// These two lines makes it a singleton
    
    private let baseUrl: String = "https://api.github.com/users/"
    private let perPageFollowers: Int = 100
    
    let avatarImageCache = NSCache<NSString, UIImage>() /// init cache
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=\(perPageFollowers)&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.noConnection))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do { 
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
        let endpoint = baseUrl + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.noConnection))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}

//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 12/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import Foundation

enum PersistanceActionType { case add, remove }

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Key { static let favorites = "favorites" }
    
    /// Updates the persistence manager
    /// - Parameters:
    ///   - favorite: follower to add or remove
    ///   - actionType: the action performed on the follower  which can be add or remove
    static func updateWith(favorite: Follower, actionType: PersistanceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):

                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completed(.alreadyFavorite)
                        return } // First we make sure the follower is not yet a favorite
                    
                    favorites.append(favorite) // If not yet favorite we append it to favorites
                case .remove:
                    favorites.removeAll { $0.login == favorite.login } // remove all instances of user.login from retrieved favorites
                }
                completed(save(favorites: favorites)) // save changes in completion handler
                
            case .failure(let error): completed(error)
            }
        }
    }
    
    /// Retrieve favorite followers from memory. Needs to decode from Data to [Follower] object
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Key.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
        
    }
    
    /// Save method for saving favorites as data
    /// - Parameter favorites: followers to convert to data to be saved
    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Key.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}

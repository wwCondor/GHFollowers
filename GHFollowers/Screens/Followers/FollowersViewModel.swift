//
//  FollowersViewModel.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 01/03/2022.
//  Copyright © 2022 CodingCondor. All rights reserved.
//

import UIKit

final class FollowersViewModel {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: GFError? = nil
    @Published private(set) var followers: [Follower] = []
    @Published private(set) var userAddedToFavourites: String? = nil
    
    var page: Int = 1
    
    /// Increases the current page by one and gets the followers for username.
    func getFollowers(for username: String, page: Int) {
        isLoading = true
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in // called a capture list
            guard let self = self else { return }
            switch result {
            case .success(let followers):
                print("ADDED: \(followers)")
                self.followers.append(contentsOf: followers)
            case .failure(let error): self.error = error
            }
            self.isLoading = false
        }
    }
    
    func clearFollowers() {
        followers.removeAll()
    }
    
    func didTapAddButton(for username: String) {
        isLoading = true
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user): self.addUserToFavorites(user: user)
            case .failure(let error): self.error = error
            }
            self.isLoading = false
        }
    }

    private func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.error = error
            } else {
                self.userAddedToFavourites = favorite.login
            }
        }
    }
}

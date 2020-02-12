//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 12/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

protocol GitHubProfileTappable: class {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate: GitHubProfileTappable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        guard let user = user else { return }
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPink, title: "Github Profile")
    }
    
    override func actionButtonTapped() {
        guard let user = user else { return }
        delegate?.didTapGitHubProfile(for: user)
    }
}

//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 12/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

protocol GitHubFollowersTappable: class {
    func didTapGitHubFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {
    
    weak var delegate: GitHubFollowersTappable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        guard let user = user else { return }
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemPink, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        guard let user = user else { return }
        delegate?.didTapGitHubFollowers(for: user)
    }
}

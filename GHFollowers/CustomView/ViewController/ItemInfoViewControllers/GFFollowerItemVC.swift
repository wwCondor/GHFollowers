//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 12/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

protocol GitHubFollowersDelegate: AnyObject {
    func didTapGitHubFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {
    
    weak var delegate: GitHubFollowersDelegate?
    
    init(user: User, delegate: GitHubFollowersDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

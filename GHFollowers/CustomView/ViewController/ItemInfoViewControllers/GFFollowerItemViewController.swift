//
//  GFFollowerItemViewController.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 11/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

protocol GitHubFollowersTappable: class {
    func didTapGitHubFollowers(for user: User)
}

class GFFollowerItemViewController: GFItemInfoViewController {
    
    weak var delegate: GitHubFollowersTappable?
    
//    init(user: User, delegate: GitHubFollowersTappable? = nil) {
//        self.delegate = delegate
//        super.init(user: user)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        guard let user = user else { return }
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemPink, title: "Get Followers")
//        actionButton.addTarget(self, action: #selector(didTapGetFollowers), for: .touchUpInside)
    }
    
    override func actionButtonTapped() {
        guard let user = user else { return }
        delegate?.didTapGitHubFollowers(for: user)
    }
    
//    @objc private func didTapGetFollowers() {
//        guard let user = user else { return }
//        if let delegate = self.delegate {
//            delegate.didTapGitHubFollowers(for: user)
//        }
//    }
}

//
//  GFRepoItemViewController.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 11/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

protocol GitHubProfileTappable: class {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemViewController: GFItemInfoViewController {
    
    weak var delegate: GitHubProfileTappable?
    
//    init(user: User, delegate: GitHubProfileTappable? = nil) {
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
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPink, title: "Github Profile")
//        actionButton.addTarget(self, action: #selector(didTapGetGitHubProfile), for: .touchUpInside)
    }
    
    override func actionButtonTapped() {
        guard let user = user else { return }
        delegate?.didTapGitHubProfile(for: user)
    }
    
//    @objc private func didTapGetGitHubProfile() {
//        guard let user = user else { return }
//        if let delegate = self.delegate {
//            delegate.didTapGitHubProfile(of: user)
//        }
//    }
}

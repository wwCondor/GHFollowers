//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 10/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    var username: String?
    
    lazy var headerView: UIView = {
        let headerView = UIView()
        return headerView
    }()
    
    lazy var itemViewOne: UIView = {
        let itemViewOne = UIView()
        return itemViewOne
    }()
    
    lazy var itemViewTwo: UIView = {
        let itemViewTwo = UIView()
        return itemViewTwo
    }()
    
    lazy var dateLabel: GFBodyLabel = {
        let dateLabel = GFBodyLabel(textAlignment: .center)
        return dateLabel
    }()
    
    var itemViews: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    private func configureViewController() {
        view.backgroundColor  = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func getUserInfo() {
        guard let username = username else { return }
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user): DispatchQueue.main.async { self.configureUIElements(for: user) }
            case .failure(let error): self.presentGFAlertOnMainThread(title: "Networking Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
    
    private func configureUIElements(for user: User) {
        let repoItemViewController          = GFRepoItemViewController(user: user)
        repoItemViewController.delegate     = self
        
        let followerItemViewController      = GFFollowerItemViewController(user: user)
        followerItemViewController.delegate = self
        
        self.add(childViewController: repoItemViewController, to: self.itemViewOne)
        self.add(childViewController: followerItemViewController, to: self.itemViewTwo)
        self.add(childViewController: GFUserInfoHeaderViewController(user: user), to: self.headerView)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
    }
    
    private func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func add(childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}

//extension UserInfoViewController: GitHubProfileTappable {
//    func didTapGitHubProfile(of user: User) {
//        let followersViewController = FollowerListViewController(username: user.login)
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
//        followersViewController.navigationItem.rightBarButtonItem = doneButton
//        followersViewController.title = user.login
//        let navigationController = UINavigationController(rootViewController: followersViewController)
//        present(navigationController, animated: true)
//    }
//}

extension UserInfoViewController: GitHubProfileTappable {
    func didTapGitHubProfile(for user: User) {
        print("Profile Tapped")
//        guard let url = URL(string: user.htmlUrl) else {
//            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid.", buttonTitle: "Ok")
//            return
//        }
        
//        presentSafariVC(with: url)
    }
}

extension UserInfoViewController: GitHubFollowersTappable {
    func didTapGitHubFollowers(for user: User) {
        print("Followers Tapped")
//        guard user.followers != 0 else {
//            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers. What a shame 😞.", buttonTitle: "So sad")
//            return
//        }
        
//        delegate.didRequestFollowers(for: user.login)
//        dismssVC()
    }
}

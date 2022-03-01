//
//  Coordinator.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 28/02/2022.
//  Copyright © 2022 CodingCondor. All rights reserved.
//

import UIKit

final class Coordinator {
    let tabBarController = UITabBarController()
    
    private lazy var searchNavigationController = createSearchNavigationController()
    private lazy var favouritesNavigationController = createFavouritesNavigationController()
    private lazy var navigationControllers = [searchNavigationController, favouritesNavigationController]
    
    init() {
        configureTabBarController()
        configureNavigationControllers()
    }
    
    func start() {
        tabBarController.viewControllers = navigationControllers
    }
    
    private func configureTabBarController() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = .systemPink
        tabBarAppearance.alpha = AlphaConfiguration.systemPinkAlpha
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = []
    }
    
    private func configureNavigationControllers() {
        navigationControllers.forEach { navigationController in
            navigationController.modalPresentationStyle = .overFullScreen
            navigationController.modalTransitionStyle = .coverVertical
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.tintColor = .systemPink
        }
    }
    
    private func createSearchNavigationController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.delegate = self
        searchViewController.title = "Search"
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchViewController)
    }
    
    private func createFavouritesNavigationController() -> UINavigationController {
        let favouritesListViewController = FavoritesViewController()
        favouritesListViewController.title = "Favourites"
        favouritesListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favouritesListViewController)
    }
    
    private func pushFollowersViewController(for username: String) {
        let followersViewController = FollowersViewController(username: username)
        
        searchNavigationController.pushViewController(followersViewController, animated: true)
    }
    
    private func presentUserInfoViewController(for follower: Follower) {
        let userInfoViewController = UserInfoViewController()
        userInfoViewController.username = follower.login
        userInfoViewController.delegate = self
    }
}

// MARK: - SearchViewControllerDelegate

extension Coordinator: SearchViewControllerDelegate {
    func didTapButton(with username: String) {
        pushFollowersViewController(for: username)
    }
    
    func didTapActionButton(for user: String) {
        
    }
}

extension Coordinator: FollowersViewControllerDelegate {
    func didTapFollower(with username: Follower) {
        //        let destinationVC                    = UserInfoViewController()
        //        destinationVC.username               = selectedFollower.login
        //        destinationVC.delegate               = self
        //        let navigationController             = UINavigationController(rootViewController: destinationVC)
        //        present(navigationController, animated: true)
    }
}

extension Coordinator: UserInfoViewControllerDelegate {
    func didRequestFollowers(for username: String) {
        
    }
}

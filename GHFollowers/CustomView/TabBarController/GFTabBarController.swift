//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 12/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [createSearchNavigationController(), createFavouritesNavigationController()]

        configureTabBarAppearance()
    }
    
    private func configureTabBarAppearance() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = .systemPink
        tabBarAppearance.alpha = Configuration.systemPinkAlpha
    }
    
    /// Creates the UINavigationController
    private func createSearchNavigationController() -> UINavigationController {
        let searchViewController = SearchVC()
        searchViewController.title = "Search"
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return   UINavigationController(rootViewController: searchViewController)
    }
    
    private func createFavouritesNavigationController() -> UINavigationController {
        let favouritesListViewController = FavoritesListViewController()
        favouritesListViewController.title = "Favourites"
        favouritesListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return   UINavigationController(rootViewController: favouritesListViewController)
    }
}

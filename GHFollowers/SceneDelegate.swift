//
//  SceneDelegate.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 06/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabBarController()
        window?.makeKeyAndVisible()
        
        configureNavigationBar()
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
    
    /// Creates the  UITabeBarController
    private func createTabBarController() -> UITabBarController {
        let tabBar = UITabBarController()
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = .systemPink
        tabBarAppearance.alpha = Configuration.systemPinkAlpha
        tabBar.viewControllers = [createSearchNavigationController(), createFavouritesNavigationController()]
        
        return tabBar
    }
    
    private func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemPink
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


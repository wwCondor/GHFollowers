//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 07/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

protocol FollowerListViewControllerDelegate: class {
    func didRequestFollowers(for username: String)
}

class FollowerListViewController: UIViewController {
    
    enum Section { case main }
    
    var username: String?
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page: Int = 1
    var hasMoreFollowers = true
    var isSearching: Bool = false
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeCollumnFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupView()
        configureSearchController()
        guard let username = username else { return }
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    private func setupView() {
        view.addSubview(collectionView)
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
    }
    
    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] (result) in // called a capture list
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow! ☺️"
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                self.updateData(on: self.followers)
//                DispatchQueue.main.async { self.updateSearchResults(for: self.searchController) }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Networking Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.identifier, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    @objc private func addButtonTapped() {
        showLoadingView()
        guard let username = username else { return }
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            switch result {
                
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Succes!", message: "You have succesfully added \(favorite.login) to favorites 🎉", buttonTitle: "Yay!")
                        return
                    }
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Ok")
                }
                
            case .failure(let error): self.presentGFAlertOnMainThread(title: "Networking Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
}

extension FollowerListViewController: UICollectionViewDelegate {
    /// When user scrolls all the way towards the bottom of the scrollView a request will be made for the next followers-page
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight {
            guard hasMoreFollowers == true else { return }
            guard let username = username else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray  = isSearching ? filteredFollowers : followers // true : false condition ( W ? T : F )
        let followerSelected = activeArray[indexPath.item]
        let destinationViewController = UserInfoViewController()
        destinationViewController.username = followerSelected.login
        let navigationController = UINavigationController(rootViewController: destinationViewController)
        present(navigationController, animated: true)
    }
}

extension FollowerListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    /// Anytime the search bar input has changes this will inform the viewController
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, filter.isNotEmpty else {
            updateData(on: followers)
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredFollowers.removeAll()
        updateData(on: followers)
    }
}

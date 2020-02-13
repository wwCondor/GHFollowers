//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 07/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

//protocol FollowerListViewControllerDelegate: class {
//    func didRequestFollowers(for username: String)
//}

class FollowerListViewController: GFDataLoadingVC {
    
    enum Section { case main }
    
    var username: String?
    var followers: [Follower]         = []
    var filteredFollowers: [Follower] = []
    var page: Int                     = 1
    var hasMoreFollowers: Bool        = true
    var isSearching: Bool             = false
    var isLoadingMoreFollowers: Bool  = false
    var lastScrollPosition: CGFloat   = 0
    
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
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        isLoadingMoreFollowers = true
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] (result) in // called a capture list
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let followers): self.updateUI(with: followers)
            case .failure(let error): self.presentGFAlertOnMainThread(title: "Networking Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
            self.isLoadingMoreFollowers = false
        }
    }
    
    private func updateUI(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers. You could be the first! ☺️"
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
            return
        }
        updateData(on: self.followers)
        DispatchQueue.main.async { self.updateSearchResults(for: self.searchController) }
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
        snapshot.deleteAllItems()
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
            case .success(let user): self.addUserToFavorites(user: user)
            case .failure(let error): self.presentGFAlertOnMainThread(title: "Networking Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
    
    private func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.presentGFAlertOnMainThread(title: "Succes!", message: "You have succesfully added \(favorite.login) to favorites 🎉", buttonTitle: "Yay!")
                return
            }
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Ok")
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
            guard hasMoreFollowers == true, isLoadingMoreFollowers == false else { return }
            guard let username = username else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray                      = isSearching ? filteredFollowers : followers // true : false condition ( W ? T : F )
        let selectedFollower                 = activeArray[indexPath.item]
        let destinationVC                    = UserInfoViewController()
        destinationVC.username               = selectedFollower.login
        destinationVC.delegate               = self
        let navigationController             = UINavigationController(rootViewController: destinationVC)
        present(navigationController, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastScrollPosition = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastScrollPosition < scrollView.contentOffset.y {
            /// We scrolled down, indicating user is browsing searchResults, so we hide searchBar
//            collapseSearchBar()
            self.navigationItem.hidesSearchBarWhenScrolling = true
        } else if lastScrollPosition > scrollView.contentOffset.y {
            /// We scrolled up, indicating user might want to edit search input
//            expandSearchBar()
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    private func collapseSearchBar() {
//            UIView.animate(withDuration: 0.4,
//                           delay: 0,
//                           options: .curveEaseInOut,
//                           animations: navigationItem.hidesSearchBarWhenScrolling = true,
//                           completion: nil )
    }
    
    private func expandSearchBar() {
//            UIView.animate(withDuration: 0.4,
//                           delay: 0,
//                           options: .curveEaseInOut,
//                           animations: self.reloadInputViews,
//                           completion: { _ in
//                            self.navigationItem.hidesSearchBarWhenScrolling = false
//            })
    }
}

extension FollowerListViewController: UISearchResultsUpdating {
    /// Anytime the search bar input has changes this will inform the viewController
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, filter.isNotEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowerListViewController: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        hasMoreFollowers = true
        self.username    = username
        title            = username
        page             = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}

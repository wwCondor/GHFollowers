//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 07/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import Combine
import UIKit

//protocol FollowerListViewControllerDelegate: class {
//    func didRequestFollowers(for username: String)
//}

protocol FollowersViewControllerDelegate: AnyObject {
    func didTapFollower(with username: Follower)
}

final class FollowersViewController: UIViewController {
    weak var delegate: FollowersViewControllerDelegate?
    
    enum Section { case main }
    
    var username: String
    var filteredFollowers: [Follower] = []
    var hasMoreFollowers: Bool = true
    var isSearching: Bool = false
    var isLoadingMoreFollowers: Bool  = false
    
    private let followersView = FollowersView()
    private let viewModel = FollowersViewModel()
    
    private var anyCancellables: [AnyCancellable] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    private let searchController = UISearchController()
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = followersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followersView.delegate = self
        configureNavigationBar()
        configureSearchController()
        setupSubscriptions()
        viewModel.getFollowers(for: username, page: viewModel.page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func addButtonTapped() {
        viewModel.didTapAddButton(for: username)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func setupSubscriptions() {
        viewModel.$followers.sink { [weak self] followers in
            guard let self = self else { return }
            self.hasMoreFollowers = (followers.count < 100) ? false : true
            self.updateUI(with: followers)
        }.store(in: &anyCancellables)
        
        viewModel.$error.sink { [weak self] error in
            guard let self = self, let error = error else { return }
            self.presentAlert(title: error.title, message: error.localizedDescription, buttonTitle: "Ok")
        }.store(in: &anyCancellables)
        
        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.showActivityIndicator()
            } else {
                self.dismissActivityIndicator()
            }
        }.store(in: &anyCancellables)
        
        viewModel.$userAddedToFavourites.sink { [weak self] user in
            guard let self = self, let user = user else { return }
            let formattedString = String.localizedStringWithFormat("You have succesfully added %@ to favorites 🎉", user)
            self.presentAlert(title: "Succes!", message: formattedString, buttonTitle: "Yay!")
        }.store(in: &anyCancellables)
    }
    
    private func updateUI(with followers: [Follower]) {
        if followers.isEmpty {
            let message = "This user doesn't have any followers. You could be the first! ☺️"
            showEmptyStateView(with: message)
        } else {
            dismissEmptyStatView()
        }
        updateData(on: followers)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: followersView.followersCollectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
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
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
            self.updateSearchResults(for: self.searchController)
        }
    }
}

// MARK: - FollowersViewDelegate

extension FollowersViewController: FollowersViewDelegate {
    func didScrollToEnd() {
        guard hasMoreFollowers == true, isLoadingMoreFollowers == false else { return }
        viewModel.page += 1
        viewModel.getFollowers(for: username, page: viewModel.page)
    }
    
    func didTapFollower(at indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : viewModel.followers
        let selectedFollower = activeArray[indexPath.item]
//        delegate?.didTapFollower(with: selectedFollower)
        let userInfoViewController = UserInfoViewController()
        userInfoViewController.username = selectedFollower.login
        userInfoViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: userInfoViewController)
        present(navigationController, animated: true)
    }
    
    func hideSearchBar(_ hidesSearchBarWhenScrolling: Bool) {
        self.navigationItem.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
    }
}

// MARK: - UISearchResultsUpdating

extension FollowersViewController: UISearchResultsUpdating {
    /// Anytime the search bar input changes this will inform the viewController
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, filter.isNotEmpty else {
            filteredFollowers.removeAll()
            updateData(on: viewModel.followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = viewModel.followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

// MARK: - UserInfoViewControllerDelegate

extension FollowersViewController: UserInfoViewControllerDelegate {
    func didRequestFollowers(for username: String) {
        hasMoreFollowers = true
        self.username = username
        title = username
        viewModel.page = 1
        viewModel.clearFollowers()
        filteredFollowers.removeAll()
        followersView.followersCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        viewModel.getFollowers(for: username, page: viewModel.page)
    }
}

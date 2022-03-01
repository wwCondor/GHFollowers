//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 12/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func didTapButton(with username: String)
}

final class SearchViewController: UIViewController {
    weak var delegate: SearchViewControllerDelegate?
    
    private let searchView = SearchView()
    
    override func loadView() {
        super.loadView()
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.delegate = self
        addDismissKeyboardGestureRecognizers()
    }
    
    /// Gets called everytime view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchView.resetUsernameTextField()
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - SearchViewDelegate

extension SearchViewController: SearchViewDelegate {
    func didTapButton(with username: String) {
        delegate?.didTapButton(with: username)
    }
    
    func didFindError(_ error: GFError) {
        presentAlert(title: error.title, message: error.localizedDescription, buttonTitle: "OK")
    }
}

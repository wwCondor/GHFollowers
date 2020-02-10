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
        headerView.translatesAutoresizingMaskIntoConstraints = false
//        headerView.backgroundColor = .systemPink
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor  = .systemBackground
        
        configureView()
        
        guard let username = username else { return }
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user): DispatchQueue.main.async { self.add(childViewController: GFUserInfoHeaderViewController(user: user), to: self.headerView) }
            case .failure(let error): self.presentGFAlertOnMainThread(title: "Networking Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
    
    private func configureView() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
        
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
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

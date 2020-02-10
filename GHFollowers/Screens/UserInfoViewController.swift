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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor  = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
        
        guard let username = username else { return }
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user): print(user)
            case .failure(let error): self.presentGFAlertOnMainThread(title: "Networking Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}

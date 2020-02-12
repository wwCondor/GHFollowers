//
//  GFUserInfoHeaderViewController.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 10/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class GFUserInfoHeaderViewController: UIViewController {
    
    var user: User?
    
    private lazy var avatarImageView: GFAvatarImageView = {
        let avatarImageView = GFAvatarImageView(frame: .zero)
        return avatarImageView
    }()

    private lazy var usernameLabel: GFTitleLabel = {
        let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
        return usernameLabel
    }()
    
    private lazy var nameLabel: GFSecondaryTitleLabel = {
        let nameLabel = GFSecondaryTitleLabel(fontSize: 18)
        return nameLabel
    }()
    
    private lazy var locationImageView: UIImageView = {
        let locationImageView = UIImageView()
        let locationImage = UIImage(systemName: SFSymbols.location)
        locationImageView.image = locationImage
        locationImageView.tintColor = .systemPink
        locationImageView.alpha = 0.65
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        return locationImageView
    }()
    
    private lazy var locationLabel: GFSecondaryTitleLabel = {
        let locationLabel = GFSecondaryTitleLabel(fontSize: 18)
        return locationLabel
    }()
    
    private lazy var bioLabel: GFBodyLabel = {
        let bioLabel = GFBodyLabel(textAlignment: .left)
        bioLabel.numberOfLines = 3
        return bioLabel
    }()
    
    convenience init(user: User) {
        self.init(nibName: nil, bundle: nil)
        self.user = user
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureUIForUser()
    }
    
    private func configureUIForUser() {
        guard let user = user else { return }
        avatarImageView.downloadImage(from: user.avatarUrl)
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? ""
        locationLabel.text = user.location ?? "No location"
        bioLabel.text = user.bio ?? "No available bio"
    }
    
    private func configureView() {
        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(nameLabel)
        view.addSubview(locationImageView)
        view.addSubview(locationLabel)
        view.addSubview(bioLabel)
        
        let textImagePadding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38), 
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 09/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    
    static let identifier = "followerCellId"
    
    lazy var avatarImageView: GFAvatarImageView = {
        let avatarImageView = GFAvatarImageView(frame: .zero)
        return avatarImageView
    }()
    
    lazy var usernameLabel: GFTitleLabel = {
        let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
        return usernameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower) {
        usernameLabel.text = follower.login
        avatarImageView.downloadImage(from: follower.avatarUrl)
    }
    
    private func configureView() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

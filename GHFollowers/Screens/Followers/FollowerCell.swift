//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 09/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

final class FollowerCell: UICollectionViewCell {
    
    static let identifier = "followerCellId"
    
    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureViewContent()
        layoutViewContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower) {
        avatarImageView.downloadImage(fromURL: follower.avatarUrl)
        usernameLabel.text = follower.login
    }
    
    private func configureView() {
        backgroundColor = UIColor.red
    }
    
    private func configureViewContent() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.layer.masksToBounds = true
        avatarImageView.image = GFImages.avatarPlaceholder
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.textAlignment = .center
        usernameLabel.textColor = .label
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.9
        usernameLabel.lineBreakMode = .byTruncatingTail
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    private func layoutViewContent() {
        addSubviews(avatarImageView, usernameLabel)
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

//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 09/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        image = UIImage(named: .avatarPlaceholder)
    }
}

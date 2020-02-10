//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 10/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class GFEmptyStateView: UIView {
    
    lazy var messageLabel: GFTitleLabel = {
        let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        return messageLabel
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: .emptyStateLogo)?.withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = .systemPink
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.alpha = 0.65
        return logoImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        configureView()
    }
    
    private func configureView() {
        addSubview(messageLabel)
        addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 40)
        ])
    }
}

//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 10/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class GFEmptyStateView: UIView {
    
    private lazy var messageLabel: GFTitleLabel = {
        let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        return messageLabel
    }()
    
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = GFImages.emptyStateLogo
        logoImageView.tintColor = .systemPink
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.alpha = AlphaConfiguration.systemPinkAlpha
        return logoImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMessageLabel()
        configureLogoImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func configureMessageLabel() {
        addSubview(messageLabel)
        
        let labelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -80 : -150
        let messageLabelCenterYConstraint = messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: labelCenterYConstant)
        messageLabelCenterYConstraint.isActive = true

        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func configureLogoImageView() {
        addSubview(logoImageView)
        
        let logoBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80 : 40
        let logoImageViewBottomConstraint = logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: logoBottomConstant)
        logoImageViewBottomConstraint.isActive = true

        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}

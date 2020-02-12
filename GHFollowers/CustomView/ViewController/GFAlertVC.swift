//
//  GFAlertVC.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 12/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class GFAlertVC: UIViewController {
    
    private var alertTitle: String?
    private var alertMessage: String?
    private var alertButtonTitle: String?
    
    private lazy var containerView: GFAlertContainerView = {
        let containerView = GFAlertContainerView()
        return containerView
    }()
    
    private lazy var titleLabel: GFTitleLabel = {
        let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
        titleLabel.text = self.alertTitle ?? "Something went wrong"
        return titleLabel
    }()
    
    private lazy var messageLabel: GFBodyLabel = {
        let messageLabel = GFBodyLabel(textAlignment: .center)
        messageLabel.text = self.alertMessage ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
        return messageLabel
    }()
     
    lazy var actionButton: GFButton = {
        let actionButton = GFButton(backgroundColor: .systemPink, title: "OK")
        actionButton.setTitle(self.alertButtonTitle, for: .normal)
        actionButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        return actionButton
    }()
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.alertMessage = message
        self.alertButtonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        configureView()
    }
    
    private func configureView() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(actionButton)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),
            
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}

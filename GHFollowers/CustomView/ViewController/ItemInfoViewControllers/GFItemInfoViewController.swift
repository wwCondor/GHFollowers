//
//  GFItemInfoViewController.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 11/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class GFItemInfoViewController: UIViewController {
    
    var user: User?
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var itemInfoViewOne: GFItemInfoView = {
        let itemInfoViewOne = GFItemInfoView()
        return itemInfoViewOne
    }()
    
    lazy var itemInfoViewTwo: GFItemInfoView = {
        let itemInfoViewTwo = GFItemInfoView()
        return itemInfoViewTwo
    }()
    
    lazy var actionButton: GFButton = {
        let actionButton = GFButton()
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return actionButton
    }()
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        layoutUI()
        configureStackViewContent()
        
    }
    
    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
//    private func configureActionButton() {
//        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
//    }
    
    @objc func actionButtonTapped() { }
    
    private func layoutUI() {
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureStackViewContent() {
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }
}

//
//  SearchView.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 01/03/2022.
//  Copyright © 2022 CodingCondor. All rights reserved.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func didTapButton(with username: String)
    func didFindError(_ error: GFError)
}

final class SearchView: UIView {
    weak var delegate: SearchViewDelegate?
        
    private let logoImageView = UIImageView()
    private let usernameTextField = UITextField()
    private let getFollowersButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureViewContent()
        layoutViewContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func resetUsernameTextField() {
        DispatchQueue.main.async {
            self.usernameTextField.text = ""
        }
    }
    
    @objc private func didTapActionButton() {
        guard let input = usernameTextField.text, input.isNotEmpty else {
            delegate?.didFindError(GFError.invalidUsername)
            return }

        delegate?.didTapButton(with: input)
    }
    
    private func configureView() {
        backgroundColor = UIColor.systemBackground
    }
    
    private func configureViewContent() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = GFImages.githubLogo
        logoImageView.contentMode = .scaleAspectFit
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.layer.borderWidth = 2
        usernameTextField.layer.borderColor = UIColor.systemGray4.cgColor
        usernameTextField.textColor = .label // Default label color
        usernameTextField.tintColor = .label // Caret color
        usernameTextField.textAlignment = .center
        usernameTextField.font = UIFont.preferredFont(forTextStyle: .title2)
        usernameTextField.adjustsFontSizeToFitWidth = true // allows text to shrink when user has longer name
        usernameTextField.minimumFontSize = 12 // set minimum shrink font-size
        usernameTextField.backgroundColor = .tertiarySystemBackground
        usernameTextField.autocorrectionType = .no
        usernameTextField.returnKeyType = .go
        usernameTextField.autocapitalizationType = .none
        usernameTextField.clearButtonMode = .whileEditing // adds clearButton to textField when editing
        usernameTextField.placeholder = "Enter a username"
        usernameTextField.delegate = self
        
        getFollowersButton.translatesAutoresizingMaskIntoConstraints = false
        getFollowersButton.layer.cornerRadius = 10
        getFollowersButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline) // Allows dynamic type
        getFollowersButton.setTitleColor(.white, for: .normal)
        getFollowersButton.backgroundColor = UIColor.systemPink
        getFollowersButton.setTitle("Get Followers", for: .normal)
        getFollowersButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    private func layoutViewContent() {
        addSubviews(logoImageView, usernameTextField, getFollowersButton)
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            getFollowersButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            getFollowersButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            getFollowersButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            getFollowersButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

// MARK: - UITextFieldDelegate

extension SearchView: UITextFieldDelegate {
    /// Gets called when user presses "Go" on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        delegate?.didTapButton(with: textField.text!)
        return true
    }
}

//
//  GFButton.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 06/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("Has not been implemted")
    }
    
    /// With this we can initialize a button quickly with its own color and title
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor =  backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline) // Allows dynamic type
        translatesAutoresizingMaskIntoConstraints = false
    }
}

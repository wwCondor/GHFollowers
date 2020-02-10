//
//  Image.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 06/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

extension UIImage {
    struct Name: RawRepresentable {
        typealias RawValue = String

        var rawValue: RawValue

        var name: String { return rawValue}

        init(rawValue: String) {
            self.rawValue = rawValue
        }

        init(name: String) {
            self.init(rawValue: name)
        }
    }

    convenience init?(named: Name) {
        self.init(named: named.name)
    }
}

extension UIImage.Name {
    static let avatarPlaceholder       = UIImage.Name(name: "avatar-placeholder")
    static let emptyStateLogo         = UIImage.Name(name: "empty-state-logo")
    static let githubLogo              = UIImage.Name(name: "gh-logo")
}

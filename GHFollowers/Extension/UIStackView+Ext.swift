//
//  UIStackView+Ext.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 13/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views { addArrangedSubview(view) }
    }
}

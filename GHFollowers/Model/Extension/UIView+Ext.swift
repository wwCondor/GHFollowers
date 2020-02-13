//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 12/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

extension UIView {
    /// Variadic Parameter
    /// This allows multiple views to be added to the subview at the same time
    /// - Parameter views: the views which are going to be added to the subview
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
    

}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views { addArrangedSubview(view) }
    }
}

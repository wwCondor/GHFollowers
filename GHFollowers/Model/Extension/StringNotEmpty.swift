//
//  StringNotEmpty.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 10/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import Foundation

extension String {
    /// Bool indicating  whether a string contains any characters
    public var isNotEmpty: Bool {
        return !self.isEmpty
    }
}

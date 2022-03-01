//
//  UIImageView+Extension.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 01/03/2022.
//  Copyright © 2022 CodingCondor. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImage(fromURL url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}

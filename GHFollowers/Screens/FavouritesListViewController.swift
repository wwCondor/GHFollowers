//
//  FavouritesListViewController.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 06/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

class FavouritesListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites): print(favorites)
            case .failure(let error): print(error)
            }
        }
    }
}

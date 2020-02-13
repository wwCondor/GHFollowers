//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 13/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit

extension UITableView {
    /// Removes the extra unused cells in the UITableView
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
    /// (Not used atm) This can be used to update erload the data on the main thread directly if there is no other action required
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
}

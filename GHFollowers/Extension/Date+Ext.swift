//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 13/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import Foundation

extension Date {
    /// Convert Date object to "Jan 2020" format
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}

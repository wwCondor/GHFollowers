//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 13/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import Foundation

extension String {
    /// Bool indicating  whether a string contains any characters
    public var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
//    /// Convert date string from JSON model to Date
//    func convertToDate() -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        dateFormatter.locale = Locale(identifier: "en_NL")
//        dateFormatter.timeZone = .current
//        return dateFormatter.date(from: self)
//    }
//
//    /// Converts the JSON string to date and back to a string, although with different format
//    func convertToDisplayFormat() -> String {
//        guard let date = self.convertToDate() else { return "" }
//        return date.convertToMonthYearFormat()
//    }
}

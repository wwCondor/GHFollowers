//
//  GFError.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 07/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import Foundation

enum GFError: Error {
    case invalidUsername
    case invalidRequest
    case noConnection
    case invalidResponse
    case invalidData
}

extension GFError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .invalidUsername:       return "Please provide a username. We need to know who to look for."
        case .invalidRequest:        return "This username created an invalid request, please try again"
        case .noConnection:          return "Unable to complete request. Please check your internet connection"
        case .invalidResponse:       return "Invalid response from server. Please try again."
        case .invalidData:           return "Data retrieved from server was invalid. Please try again."

        }
    }
}

//enum ErrorMessage: String {
//    case invalidUsername = "Please provide a username. We need to know who to look for."
//    case invalidRequest = "This username created an invalid request, please try again"
//    case noConnection = "Unable to complete request. Please check your internet connection"
//    case invalidResponse = "Invalid response from server. Please try again."
//    case invalidData = "Data retrieved from server was invalid. Please try again."
//}

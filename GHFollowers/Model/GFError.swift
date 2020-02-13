//
//  GFError.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 10/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import Foundation

enum GFError: Error {
    case invalidUsername
    case invalidRequest
    case noConnection
    case invalidResponse
    case invalidData
    case invalidUrl
    case unableToFavorite
    case alreadyFavorite
    case noFollowers
}

extension GFError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .invalidUsername:       return "Please provide a username. We need to know who to look for."
        case .invalidRequest:        return "This username created an invalid request, please try again"
        case .noConnection:          return "Unable to complete request. Please check your internet connection"
        case .invalidResponse:       return "Invalid response from server. Please try again."
        case .invalidData:           return "Data retrieved from server was invalid. Please try again."
        case .invalidUrl:            return "The url attached to this user is invalid."
        case .unableToFavorite:      return "There was an error favoriting user. Please try again."
        case .alreadyFavorite:       return "You've already added this user to your favorites"
        case .noFollowers:           return "The user you selected has no followers. What a shame 😟"

        }
    }
}

//
//  AuthResponse.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 21.02.2024.
//

import Foundation

import Foundation

struct AuthResponse: Codable {
    let oauth: Oauth
}

// MARK: - Oauth
struct Oauth: Codable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    let refreshToken: String
    
    enum CodingKeys: String,CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
    }
}

//
//  Token.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 21.02.2024.
//

import Foundation

struct Token:Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
    
}

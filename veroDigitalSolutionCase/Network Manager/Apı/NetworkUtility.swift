//
//  NetworkUtility.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 21.02.2024.
//

import Foundation
import Alamofire


struct Header {
    static let shared = Header()
    func header() -> HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz"
        ]
    }
}

enum NetworkResponse<T> {
    case success(T)
    case messageFailure(ErrorMessage)
}
extension Data {
    func decode<T: Decodable>() throws -> T {
        return (try! JSONDecoder().decode(T.self, from: self))
    }
}

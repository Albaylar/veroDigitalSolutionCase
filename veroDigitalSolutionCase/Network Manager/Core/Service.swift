//
//  Service.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 21.02.2024.
//

import Foundation
import Alamofire


class Service {
    static let shared = Service()

    private let baseURL = "https://api.baubuddy.de/dev/index.php/v1/tasks/select"
    private let loginURL = "https://api.baubuddy.de/index.php/login"
    private let headers: HTTPHeaders = [
        "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz",
        "Content-Type": "application/json"
    ]
    private var accessToken: String?

    private init() {}

    func login(completion: @escaping (Result<String, Error>) -> Void) {
        let parameters: [String: Any] = [
            "username": "365",
            "password": "1"
        ]
        
        AF.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Response:", value) // Sunucudan dönen yanıtı yazdır
                    if let json = value as? [String: Any],
                       let oauth = json["oauth"] as? [String: Any],
                       let accessToken = oauth["access_token"] as? String {
                        self.accessToken = accessToken
                        completion(.success(accessToken))
                    } else {
                        completion(.failure(NSError(domain: "Service", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func fetchData(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        guard let accessToken = accessToken else {
            completion(.failure(NSError(domain: "Service", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]

        AF.request(baseURL, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [TaskModel].self) { response in
                switch response.result {
                case .success(let tasks):
                    completion(.success(tasks))
                    print(tasks)
                case .failure(let error):
                    print("FetchData Error:", error) // Hata mesajını yazdır
                    completion(.failure(error))
                }
            }
    }

}





//
//  APIManager.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/04/07.
//

import Foundation

enum Endpoint: String {
    case search = "search/photos"
}

final class APIManager {
    func url(endpoint: Endpoint, params: [String: String]) -> URL? {
        var baseUrl = "https://api.unsplash.com/" + endpoint.rawValue + "?" 
        
        var queryItems = [URLQueryItem]()
        
        for (name, value) in params {
            queryItems.append(.init(name: name, value: value))
        }
        
        queryItems.append(.init(name: "client_id", value: Bundle.main.apiKey))
        
        baseUrl += queryItems.map { "\($0.name)=\($0.value ?? "")" }.sorted(by: <).joined(separator: "&")
        
        return URL(string: baseUrl)
    }
}

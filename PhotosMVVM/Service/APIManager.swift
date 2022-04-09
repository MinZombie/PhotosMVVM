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

protocol ServiceProtocol {
    func search(query: String, completion: @escaping (Photos) -> Void)
}

final class APIManager: ServiceProtocol {
    
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    func search(query: String, completion: @escaping (Photos) -> Void) {
        request(
            url: url(
                endpoint: .search,
                params: [
                    "page" : "1",
                    "query": query
                ]
            ),
            completion: completion
        )
    }
    
    func request(url: URL?, completion: @escaping (Photos) -> Void) {
        guard let url = url else { return }
        
        let task = urlSession.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            do {
                
                let result = try JSONDecoder().decode(Photos.self, from: data)
                completion(result)
            } catch {
                
                return
            }
        }
        task.resume()
    }
    
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

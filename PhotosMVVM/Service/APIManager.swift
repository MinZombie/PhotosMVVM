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
    func search(query: String, page: Int, completion: @escaping (Result<PhotoSearchResponse, Error>) -> Void)
}

final class APIManager: ServiceProtocol {
    
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    func search(query: String, page: Int, completion: @escaping (Result<PhotoSearchResponse, Error>) -> Void) {
        request(
            url: url(
                endpoint: .search,
                params: [
                    "page" : "\(page)",
                    "query": query
                ]
            ),
            completion: completion
        )
    }
    
    func request(url: URL?, completion: @escaping (Result<PhotoSearchResponse, Error>) -> Void) {
        guard let url = url else { return }
        
        let task = urlSession.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            do {
                
                let result = try JSONDecoder().decode(PhotoSearchResponse.self, from: data)
                completion(.success(result))
            } catch {
                
                completion(.failure(error))
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
        queryItems.append(.init(name: "orientation", value: "portrait"))
        
        baseUrl += queryItems.map { "\($0.name)=\($0.value ?? "")" }.sorted(by: <).joined(separator: "&")
        
        return URL(string: baseUrl)
    }
}

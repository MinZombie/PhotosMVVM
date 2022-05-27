//
//  Model.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/04/07.
//

import Foundation

struct PhotoSearchResponse: Codable {
    var total: Int
    var totalPages: Int
    var results: [Result]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
    
    struct Result: Codable {
        var id: String
        var urls: Thumbnail
        
        struct Thumbnail: Codable {
            var thumb: String
        }
    }
}

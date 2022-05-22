//
//  Model.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/04/07.
//

import Foundation

struct Photos: Codable {
    var total: Int
    var totalPages: Int
    var results: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct Photo: Codable {
    var id: String
    var urls: Thumbnail
}

struct Thumbnail: Codable {
    var thumb: String
}

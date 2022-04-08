//
//  Model.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/04/07.
//

import Foundation

struct Photos: Codable {
    var total: Int
    var results: [Photo]
}

struct Photo: Codable {
    var id: String
    var urls: Thumbnail
}

struct Thumbnail: Codable {
    var thumb: String
}

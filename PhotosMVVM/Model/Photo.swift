//
//  Photo.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/05/27.
//

import Foundation

struct Photo {
    var id: String
    var imagePath: String
    var isFavorite: Bool
    
    init(
        id: String,
        imagePath: String,
        isFavorite: Bool
    ) {
        self.id = id
        self.imagePath = imagePath
        self.isFavorite = isFavorite
    }
}

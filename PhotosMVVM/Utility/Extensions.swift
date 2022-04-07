//
//  Extensions.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/04/07.
//

import Foundation

// MARK: - Bundle
extension Bundle {
    var apiKey: String {
        guard let file = path(forResource: "Info", ofType: "plist") else { return "" }
        
        guard let plist = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = plist["API_KEY"] as? String else { fatalError() }
        return key
    }
}

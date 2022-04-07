//
//  PhotosMVVMTests.swift
//  PhotosMVVMTests
//
//  Created by 민선기 on 2022/04/07.
//

import XCTest
@testable import PhotosMVVM

class PhotosMVVMTests: XCTestCase {
    
    var service: APIManager!
    
    override func setUp() {
        service = APIManager()
    }

    func test_url주소가_제대로_반환되는지() {
        let expectedUrl = "https://api.unsplash.com/search/photos?client_id=\(Bundle.main.apiKey)&page=1&query=canada"
        let result = service.url(
            endpoint: .search,
            params: [
                "page" : "1",
                "query": "canada"
            ]
        )
        
        if let result = result {
            XCTAssertEqual(expectedUrl, result.absoluteString)
        } else {
            XCTFail()
        }
    }

}

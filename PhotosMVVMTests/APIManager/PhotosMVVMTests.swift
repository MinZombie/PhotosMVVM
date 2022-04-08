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
    var urlSession: URLSessionProtocol!
    var dummy: DummyData!
    
    override func setUp() {
        let photos = Photos(total: 10000, results: [Photo(id: "1", urls: Thumbnail(thumb: "https://images.unsplash.com/photo-1517935706615-2717063c2225?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyMDc5NzV8MHwxfHNlYXJjaHwxfHxjYW5hZGF8ZW58MHx8fHwxNjQ5MzI4NzYw&ixlib=rb-1.2.1&q=80&w=200"))])
        let data = try! JSONEncoder().encode(photos)
        dummy = DummyData(data: data, response: nil, error: nil)
        urlSession = StubURLSession(dummy: dummy)
        service = APIManager(urlSession: urlSession)

    }
    
    func test_request함수가_decode되는지() {
        let promise = expectation(description: "반환값 10000")
        let expectedPhotos = Photos(total: 10000, results: [Photo(id: "1", urls: Thumbnail(thumb: "https://images.unsplash.com/photo-1517935706615-2717063c2225?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyMDc5NzV8MHwxfHNlYXJjaHwxfHxjYW5hZGF8ZW58MHx8fHwxNjQ5MzI4NzYw&ixlib=rb-1.2.1&q=80&w=200"))])

        service.request { result in

            XCTAssertEqual(expectedPhotos.total, result.total)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5.0)
        
        
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

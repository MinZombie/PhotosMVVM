//
//  PhotosMVVMTests.swift
//  PhotosMVVMTests
//
//  Created by 민선기 on 2022/04/07.
//

import XCTest
@testable import PhotosMVVM

class APIManagerTests: XCTestCase {
    
    var service: APIManager!
    var urlSession: URLSessionProtocol!
    var dummy: DummyData!
    let urlString = "https://api.unsplash.com/search/photos?client_id=\(Bundle.main.apiKey)&orientation=portrait&page=1&query=canada"
    let mockPhotos = PhotoSearchResponse(total: 10000, totalPages: 1000, results: [.init(id: "1", urls: .init(thumb: "https://images.unsplash.com/photo-1517935706615-2717063c2225?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyMDc5NzV8MHwxfHNlYXJjaHwxfHxjYW5hZGF8ZW58MHx8fHwxNjQ5MzI4NzYw&ixlib=rb-1.2.1&q=80&w=200"))])
    
    override func setUp() {
        let data = try! JSONEncoder().encode(self.mockPhotos)
        dummy = DummyData(data: data, response: nil, error: nil)
        urlSession = StubURLSession(dummy: dummy)
        service = APIManager(urlSession: urlSession)

    }
    
    override func tearDown() {
        service = nil
        urlSession = nil
        dummy = nil
    }
    
    func test_request함수가_decode되는지() {
        let promise = expectation(description: "반환값 10000")

        service.request(url: URL(string: "a")) { result in

            switch result {
            case .success(let photos):
                XCTAssertEqual(self.mockPhotos.total, photos.total)
                promise.fulfill()
                
            case .failure(_):
                XCTFail()
                promise.fulfill()
            }
        }
        
        wait(for: [promise], timeout: 5.0)
        
        
    }

    func test_url주소가_제대로_반환되는지() {
        let result = service.url(
            endpoint: .search,
            params: [
                "page" : "1",
                "query": "canada"
            ]
        )
        
        if let result = result {
            XCTAssertEqual(self.urlString, result.absoluteString)
        } else {
            XCTFail()
        }
    }

}

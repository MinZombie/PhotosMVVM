//
//  SearchViewModelTests.swift
//  PhotosMVVMTests
//
//  Created by 민선기 on 2022/04/08.
//

import XCTest
@testable import PhotosMVVM

class SearchViewModelTests: XCTestCase {
    
    var service: MockPhotoService!
    var viewModel: DefaultSearchViewModel!
    

    override func setUpWithError() throws {
        service = MockPhotoService()
        viewModel = DefaultSearchViewModel(service: service)
        
    }

    override func tearDownWithError() throws {
        service = nil
        viewModel = nil
    }
    
    func test_Result타입이_failure일때_에러가나는지() {
        // given
        service.mockResult = .failure(NSError())
        
        // when
        viewModel.search(text: "dortmund")
        
        // then
        XCTAssertNotNil(viewModel.photos)
    }

    func test_Result타입이_success일때_photos변수가_잘_저장이되는지() {
        
        // given
        let photos = Photos(total: 10000, results: [Photo(id: "1", urls: Thumbnail(thumb: "www"))])
        service.mockResult = .success(photos)
        
        // when
        viewModel.search(text: "canada")
        
        
        // then
        XCTAssertNotNil(viewModel.photos)
    }
    
    
}

class MockPhotoService: ServiceProtocol {
    var mockResult: Result<Photos, Error>?
    func search(query: String, completion: @escaping (Result<Photos, Error>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
}

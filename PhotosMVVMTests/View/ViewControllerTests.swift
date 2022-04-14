//
//  ViewControllerTests.swift
//  PhotosMVVMTests
//
//  Created by 민선기 on 2022/04/11.
//

import XCTest
@testable import PhotosMVVM

class ViewControllerTests: XCTestCase {
    
    var mockViewModel: MockViewModel!
    var vc: ViewController!
    
    override func setUp() {
        mockViewModel = MockViewModel()
        vc = ViewController(viewModel: mockViewModel)
        vc.loadViewIfNeeded()
    }
    
    override func tearDown() {
        mockViewModel = nil
        vc = nil
    }

    func test_viewcontroller() {
        // given
        let searchBar = vc.searchController.searchBar
        
        // when
        searchBar.text = "hello swift"
        searchBar.delegate?.searchBarSearchButtonClicked?(
            searchBar
        )
        
        // then
        XCTAssertEqual(mockViewModel.inputText, "hello swift")
    }

}

class MockViewModel: SearchViewModel {
    
    var receivedImageView: UIImageView!
    var inputText: String = ""
    var photos: Observable<[Photo]?> = Observable(
        [
            Photo(id: "1", urls: Thumbnail(thumb: "a")),
            Photo(id: "2", urls: Thumbnail(thumb: "b")),
        ]
    )
    
    func search(text: String) {
        self.inputText = text
    }
}

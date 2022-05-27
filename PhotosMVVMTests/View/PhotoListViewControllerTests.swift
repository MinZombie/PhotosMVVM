//
//  ViewControllerTests.swift
//  PhotosMVVMTests
//
//  Created by 민선기 on 2022/04/11.
//

import XCTest
@testable import PhotosMVVM

class PhotoListViewControllerTests: XCTestCase {
    
    var mockViewModel: MockViewModel!
    var vc: PhotoListViewController!
    
    override func setUp() {
        mockViewModel = MockViewModel()
        vc = PhotoListViewController(viewModel: mockViewModel)
        vc.loadViewIfNeeded()
    }
    
    override func tearDown() {
        mockViewModel = nil
        vc = nil
    }

    func test_서치바의_서치버튼을_눌렀을때_잘_동작하는지() {
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
    var inputText: String = ""

    var isLoading: Observable<Bool> = Observable(true)
    var photos: Observable<[Photo]> = Observable(
        [
            Photo(id: "1", imagePath: "www", isFavorite: true),
            Photo(id: "2", imagePath: "www", isFavorite: false)
        ]
    )
    
    func search(text: String) {
        self.inputText = text
    }
    
    func fetchNextPage() {
        
    }
}

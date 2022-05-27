//
//  ViewModel.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/04/07.
//

import Foundation

protocol SearchViewModelInput {
    func search(text: String)
    func fetchNextPage()
}

protocol SearchViewModelOutput {
    var photos: Observable<[Photo]> { get }
    var isLoading: Observable<Bool> { get }
}

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput {
    
}

final class DefaultSearchViewModel: SearchViewModel {
    // MARK: - Properties
    private var page: Int = 0
    private var totalPages: Int = 1
    private var query: String = ""
    
    
    // MARK: - Output
    var photos: Observable<[Photo]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    
    var service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
}

extension DefaultSearchViewModel {
    // MARK: - Input
    func search(text: String) {
        self.isLoading.value = true
        self.page = 1
        self.query = text
        
        service.search(query: text, page: self.page) { photos in
            self.isLoading.value = false
            
            switch photos {
            case .success(let response):
                var photos = [Photo]()
                response.results.forEach { result in
                    
                    let photo = Photo(id: result.id, imagePath: result.urls.thumb, isFavorite: false)
                    photos.append(photo)
                }
                
                self.photos.value = photos
                self.totalPages = response.totalPages
                
            case .failure(let error):
                print("error - \(error.localizedDescription)")
            }
        }
    }
    
    func fetchNextPage() {
        guard self.page < self.totalPages else { return }
        
        self.page += 1
        
        service.search(
            query: self.query,
            page: self.page
        ) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    
                    response.results.forEach { result in
                        self.photos.value.append(
                            .init(
                                id: result.id,
                                imagePath: result.urls.thumb,
                                isFavorite: false
                            )
                        )
                    }
                        
                case .failure(let error):
                    print(error)
                }
                
            }
    }
}

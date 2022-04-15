//
//  ViewModel.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/04/07.
//

import Foundation

protocol SearchViewModelInput {
    func search(text: String)
}

protocol SearchViewModelOutput {
    var photos: Observable<[Photo]?> { get }
    var isLoading: Observable<Bool> { get }
}

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput {
    
}

final class DefaultSearchViewModel: SearchViewModel {
    var photos: Observable<[Photo]?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    
    var service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
}

extension DefaultSearchViewModel {
    func search(text: String) {
        self.isLoading.value = true
        
        service.search(query: text) { photos in
            self.isLoading.value = false
            
            switch photos {
            case .success(let photos):
                
                self.photos.value = photos.results
                
            case .failure(let error):
                print("error - \(error.localizedDescription)")
            }
        }
    }
}

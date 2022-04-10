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
}

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput {
    
}

final class DefaultSearchViewModel: SearchViewModel {
    var photos: Observable<[Photo]?> = Observable(nil)
    
    
    var service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
}

extension DefaultSearchViewModel {
    func search(text: String) {
        service.search(query: text) { photos in
            switch photos {
            case .success(let photos):
                
                self.photos.value = photos.results
            
            case .failure(let error):
                print("error - \(error.localizedDescription)")
            }
        }
    }
}

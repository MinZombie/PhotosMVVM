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
    func toggleFavoriteButton(item: Photo)
    func loadAllFavoritePhotos()
}

protocol SearchViewModelOutput {
    var photos: Observable<[Photo]> { get }
    var favoritePhotos: Observable<[Photo]> { get }
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
    var favoritePhotos: Observable<[Photo]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    
    var service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
}

// MARK: - Private
extension DefaultSearchViewModel {
    private func getFavoritePhotoId(response: PhotoSearchResponse) -> Set<String?> {
        let favoritePhotoId = Set(CoreDataManager.shared.get().map { $0.id })
        let searchedPhotoId = Set(response.results.map { $0.id })
        return favoritePhotoId.intersection(searchedPhotoId)
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
                var temp = [Photo]()
                let idForFavorite = self.getFavoritePhotoId(response: response)
                
                response.results.forEach { result in
                    
                    let photo = Photo(
                        id: result.id,
                        imagePath: result.urls.thumb,
                        isFavorite: idForFavorite.contains(result.id) ? true : false
                    )
                    temp.append(photo)
                }
                
                self.photos.value = temp
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
                    
                    let idForFavorite = self.getFavoritePhotoId(response: response)
                    
                    response.results.forEach { result in
                        self.photos.value.append(
                            .init(
                                id: result.id,
                                imagePath: result.urls.thumb,
                                isFavorite: idForFavorite.contains(result.id) ? true : false
                            )
                        )
                    }
                        
                case .failure(let error):
                    print(error)
                }
                
            }
    }
    
    func toggleFavoriteButton(item: Photo) {        
        
        if item.isFavorite {
            CoreDataManager.shared.delete(id: item.id)

            let filtered = favoritePhotos.value.filter { $0.id != item.id }
            favoritePhotos.value = filtered
            for i in 0..<photos.value.count {
                if photos.value[i].id == item.id {
                    photos.value[i].isFavorite = false
                }
            }
            
        } else {

            CoreDataManager.shared.save(model: item)
            favoritePhotos.value.append(
                .init(
                    id: item.id,
                    imagePath: item.imagePath,
                    isFavorite: true
                )
            )
            for i in 0..<photos.value.count {
                if photos.value[i].id == item.id {
                    photos.value[i].isFavorite = true
                }
            }
        }
    }
    
    func loadAllFavoritePhotos() {
        var temp = [Photo]()
        let coreData = CoreDataManager.shared.get()
        coreData.forEach {
            temp.append(
                .init(
                    id: $0.id ?? "",
                    imagePath: $0.imagePath ?? "",
                    isFavorite: $0.isFavorite
                )
            )
        }
        self.favoritePhotos.value = temp
    }
}

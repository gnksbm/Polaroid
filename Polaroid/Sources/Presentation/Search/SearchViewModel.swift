//
//  SearchViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Combine
import Foundation

final class SearchViewModel: ViewModel {
    private let searchRepository = SearchRepository.shared
    private let favoriteRepository = FavoriteRepository.shared
    
    private var currentImage = Observable<[LikableImage]>([])
    private var observableBag = ObservableBag()
    private var cancelBag = CancelBag()
    private var page = 1
    
    func transform(input: Input) -> Output {
        let output = Output(
            searchState: Observable<SearchState>(.none),
            changedImage: Observable<LikableImage?>(nil),
            onError: Observable<Void>(()), 
            startDetailFlow: Observable<LikableImage?>(nil)
        )
        
        currentImage
            .bind { images in
                output.searchState.onNext(.result(images))
            }
            .store(in: &observableBag)
        
        input.viewWillAppearEvent
            .bind { [weak self] _ in
                guard let self else { return }
                let newImages = favoriteRepository.reConfigureImages(
                    currentImage.value()
                )
                currentImage.onNext(newImages)
            }
            .store(in: &observableBag)
        
        input.searchTextChangeEvent
            .bind { searchQuery in
                if searchQuery.isEmpty {
                    output.searchState.onNext(.emptyQuery)
                }
            }
            .store(in: &observableBag)
        
        input.queryEnterEvent
            .bind { [weak self] searchQuery in
                guard let self,
                      output.searchState.value().isSearchAllowed else {
                    return
                }
                page = 1
                search(input: input, output: output) { images in
                    self.currentImage.onNext(images)
                }
                output.searchState.onNext(.searching)
            }
            .store(in: &observableBag)
        
        input.scrollReachedBottomEvent
            .bind { [weak self] _ in
                guard let self,
                      output.searchState.value().isSearchAllowed else {
                    return
                }
                page += 1
                search(input: input, output: output) { images in
                    self.currentImage.onNext(
                        self.currentImage.value() + images
                    )
                }
                output.searchState.onNext(.searching)
            }
            .store(in: &observableBag)
        
        input.likeButtonTapEvent
            .sink { [weak self] imageData in
                guard let self,
                      let imageData else { return }
                do {
                    if imageData.item.isLiked {
                        let newImage =
                        try favoriteRepository.removeImage(imageData.item)
                        output.changedImage.onNext(newImage)
                    } else {
                        var copy = imageData
                        copy.item.color =
                        input.colorOptionSelectEvent.value?.rawValue
                        let newImage = try favoriteRepository.saveImage(copy)
                        output.changedImage.onNext(newImage)
                    }
                } catch {
                    Logger.error(error)
                    output.onError.onNext(())
                }
            }
            .store(in: &cancelBag)
        
        input.colorOptionSelectEvent
            .sink { [weak self] _ in
                guard let self,
                      output.searchState.value().isSearchAllowed else {
                    return
                }
                page += 1
                search(input: input, output: output) { images in
                    self.currentImage.onNext(images)
                }
                output.searchState.onNext(.searching)
            }
            .store(in: &cancelBag)
        
        input.sortOptionSelectEvent
            .bind { [weak self] _ in
                guard let self,
                      output.searchState.value().isSearchAllowed else {
                    return
                }
                page += 1
                search(input: input, output: output) { images in
                    self.currentImage.onNext(images)
                }
                output.searchState.onNext(.searching)
            }
            .store(in: &observableBag)
        
        input.itemSelectEvent
            .bind(to: output.startDetailFlow)
            .store(in: &observableBag)
        
        return output
    }
    
    private func search(
        input: Input,
        output: Output,
        _ completion: @escaping ([LikableImage]) -> Void
    ) {
        do {
            let query = input.searchTextChangeEvent.value()
            try query.validate(validator: UnsplashSearchValidator())
            searchRepository.search(
                request: SearchRequest(
                    keyword: query,
                    page: page,
                    sortOption: input.sortOptionSelectEvent.value(),
                    color: input.colorOptionSelectEvent.value
                )
            ) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    if success.page == page {
                        output.searchState.onNext(.finalPage)
                    }
                    completion(
                        favoriteRepository.reConfigureImages(success.images)
                    )
                case .failure(let error):
                    Logger.error(error)
                    output.onError.onNext(())
                }
            }
        } catch {
            output.searchState.onNext(.emptyQuery)
        }
    }
}

extension SearchViewModel {
    struct Input { 
        let viewWillAppearEvent: Observable<Void>
        let searchTextChangeEvent: Observable<String>
        let queryEnterEvent: Observable<String>
        let scrollReachedBottomEvent: Observable<Void>
        let sortOptionSelectEvent: Observable<SearchSortOption>
        let colorOptionSelectEvent: CurrentValueSubject<ColorOption?, Never>
        let likeButtonTapEvent: CurrentValueSubject<LikableImageData?, Never>
        let itemSelectEvent: Observable<LikableImage?>
    }
    
    struct Output {
        let searchState: Observable<SearchState>
        let changedImage: Observable<LikableImage?>
        let onError: Observable<Void>
        let startDetailFlow: Observable<LikableImage?>
    }
    
    enum SearchState: Equatable {
        case emptyQuery, searching
        case result([LikableImage]), finalPage
        case none
        
        var isSearchAllowed: Bool {
            switch self {
            case .emptyQuery, .none, .result:
                true
            case .searching, .finalPage:
                false
            }
        }
    }
}

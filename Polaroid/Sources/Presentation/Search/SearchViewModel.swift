//
//  SearchViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

final class SearchViewModel: ViewModel {
    private let searchRepository = SearchRepository()
    private let favoriteRepository = FavoriteRepository()
    
    private var currentImage = ObservableBag()
    private var observableBag = ObservableBag()
    private var page = 1
    
    func transform(input: Input) -> Output {
        let output = Output(
            searchState: Observable<SearchState>(.none),
            changedImage: Observable<LikableImage?>(nil),
            onError: Observable<Void>(())
        )
        
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
                      !searchQuery.isEmpty,
                      output.searchState.value().isSearchAllowed else {
                    return
                }
                page = 1
                search(input: input, output: output) { images in
                    output.searchState.onNext(.result(images))
                }
                output.searchState.onNext(.searching)
            }
            .store(in: &observableBag)
        
        input.scrollReachedBottomEvent
            .bind { [weak self] _ in
                guard let self,
                      !input.searchTextChangeEvent.value().isEmpty,
                      output.searchState.value().isSearchAllowed else {
                    return
                }
                page += 1
                search(input: input, output: output) { images in
                    output.searchState.onNext(.nextPage(images))
                }
                output.searchState.onNext(.searching)
            }
            .store(in: &observableBag)
        
        input.likeButtonTapEvent
            .bind { [weak self] imageData in
                guard let self,
                      let imageData else { return }
                if imageData.item.isLiked {
                    do {
                        let newImage =
                        try favoriteRepository.removeImage(imageData.item)
                        output.changedImage.onNext(newImage)
                    } catch {
                        Logger.error(error)
                        output.onError.onNext(())
                    }
                } else {
                    do {
                        let newImage = 
                        try favoriteRepository.saveImage(imageData)
                        output.changedImage.onNext(newImage)
                    } catch {
                        Logger.error(error)
                        output.onError.onNext(())
                    }
                }
            }
            .store(in: &observableBag)
        
        return output
    }
    
    private func search(
        input: Input,
        output: Output,
        _ completion: @escaping ([LikableImage]) -> Void
    ) {
        searchRepository.search(
            request: SearchRequest(
                keyword: input.searchTextChangeEvent.value(),
                page: page,
                sortOption: input.sortOptionSelectEvent.value(),
                color: input.colorOptionSelectEvent.value()
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
    }
}

extension SearchViewModel {
    struct Input { 
        let searchTextChangeEvent: Observable<String>
        let queryEnterEvent: Observable<String>
        let scrollReachedBottomEvent: Observable<Void>
        let sortOptionSelectEvent: Observable<SearchSortOption>
        let colorOptionSelectEvent: Observable<ColorOption?>
        let likeButtonTapEvent: Observable<LikableImageData?>
    }
    
    struct Output {
        let searchState: Observable<SearchState>
        let changedImage: Observable<LikableImage?>
        let onError: Observable<Void>
    }
    
    enum SearchState: Equatable {
        case emptyQuery, searching
        case result([LikableImage]), nextPage([LikableImage]), finalPage
        case none
        
        var isSearchAllowed: Bool {
            switch self {
            case .emptyQuery, .none, .result, .nextPage:
                true
            case .searching, .finalPage:
                false
            }
        }
    }
}

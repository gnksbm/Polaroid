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
    
    private var currentImage = CurrentValueSubject<[LikableImage], Never>([])
    private var page = 1
    
    func transform(input: Input, cancelBag: inout CancelBag) -> Output {
        let output = Output(
            searchState: CurrentValueSubject(.none),
            changedImage: PassthroughSubject(),
            onError: PassthroughSubject(),
            startDetailFlow: input.itemSelectEvent
        )
        
        cancelBag.insert {
            currentImage
                .sink { images in
                    output.searchState.send(.result(images))
                }
            
            input.viewWillAppearEvent
                .sink(with: self) { vm, _ in
                    let newImages = vm.favoriteRepository.reConfigureImages(
                        vm.currentImage.value
                    )
                    vm.currentImage.send(newImages)
                }
            
            input.searchTextChangeEvent
                .sink { searchQuery in
                    if searchQuery.isEmpty {
                        output.searchState.send(.emptyQuery)
                    }
                }
            
            input.queryEnterEvent
                .sink(with: self) { vm, searchQuery in
                    guard output.searchState.value.isSearchAllowed 
                    else { return }
                    vm.page = 1
                    vm.search(input: input, output: output) { images in
                        vm.currentImage.send(images)
                    }
                }
            
            input.scrollReachedBottomEvent
                .sink(with: self) { vm, _ in
                    guard output.searchState.value.isSearchAllowed 
                    else { return }
                    vm.page += 1
                    vm.search(input: input, output: output) { images in
                        vm.currentImage.send(
                            vm.currentImage.value + images
                        )
                    }
                }
            
            input.likeButtonTapEvent
                .sink(with: self) { vm, imageData in
                    do {
                        var newImage: LikableImage
                        if imageData.item.isLiked {
                            newImage =
                            try vm.favoriteRepository.removeImage(
                                imageData.item
                            )
                        } else {
                            var copy = imageData
                            copy.item.color =
                            input.colorOptionSelectEvent.value?.rawValue
                            newImage = try vm.favoriteRepository.saveImage(copy)
                        }
                        output.changedImage.send(newImage)
                    } catch {
                        Logger.error(error)
                        output.onError.send(())
                    }
                }
            
            input.colorOptionSelectEvent
                .dropFirst()
                .sink(with: self) { vm, _ in
                    guard output.searchState.value.isSearchAllowed
                    else { return }
                    vm.page += 1
                    vm.search(input: input, output: output) { images in
                        vm.currentImage.send(images)
                    }
                }
            
            input.sortOptionSelectEvent
                .dropFirst()
                .sink(with: self) { vm, _ in
                    guard output.searchState.value.isSearchAllowed 
                    else { return }
                    vm.page += 1
                    vm.search(input: input, output: output) { images in
                        vm.currentImage.send(images)
                    }
                }
        }
        
        return output
    }
    
    private func search(
        input: Input,
        output: Output,
        _ completion: @escaping ([LikableImage]) -> Void
    ) {
        do {
            let query = input.searchTextChangeEvent.value
            try query.validate(validator: UnsplashSearchValidator())
            output.searchState.send(.searching)
            searchRepository.search(
                request: SearchRequest(
                    keyword: query,
                    page: page,
                    sortOption: input.sortOptionSelectEvent.value,
                    color: input.colorOptionSelectEvent.value
                )
            ) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    if success.page == page {
                        output.searchState.send(.finalPage)
                    }
                    completion(
                        favoriteRepository.reConfigureImages(success.images)
                    )
                case .failure(let error):
                    Logger.error(error)
                    output.onError.send(())
                    output.searchState.send(.none)
                }
            }
        } catch {
            output.searchState.send(.emptyQuery)
        }
    }
}

extension SearchViewModel {
    struct Input { 
        let viewWillAppearEvent: AnyPublisher<Void, Never>
        let searchTextChangeEvent: CurrentValueSubject<String, Never>
        let queryEnterEvent: AnyPublisher<String, Never>
        let scrollReachedBottomEvent: AnyPublisher<Void, Never>
        let sortOptionSelectEvent: CurrentValueSubject<SearchSortOption, Never>
        let colorOptionSelectEvent: CurrentValueSubject<ColorOption?, Never>
        let likeButtonTapEvent: PassthroughSubject<LikableImageData, Never>
        let itemSelectEvent: PassthroughSubject<LikableImage, Never>
    }
    
    struct Output {
        let searchState: CurrentValueSubject<SearchState, Never>
        let changedImage: PassthroughSubject<LikableImage, Never>
        let onError: PassthroughSubject<Void, Never>
        let startDetailFlow: PassthroughSubject<LikableImage, Never>
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

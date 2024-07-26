//
//  SearchViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

final class SearchViewModel: ViewModel {
    private let searchRepository = SearchRepository()
    
    private var observableBag = ObservableBag()
    private var page = 1
    
    func transform(input: Input) -> Output {
        let output = Output(
            searchState: Observable<SearchState>(.none),
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
            switch result {
            case .success(let success):
                if success.page == self?.page {
                    output.searchState.onNext(.finalPage)
                }
                completion(success.images)
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
        let sortOptionSelectEvent: Observable<SortOption>
        let colorOptionSelectEvent: Observable<ColorOption?>
    }
    
    struct Output {
        let searchState: Observable<SearchState>
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

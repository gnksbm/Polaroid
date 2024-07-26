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
                      !searchQuery.isEmpty else {
                    return
                }
                page = 1
                searchRepository.search(
                    request: SearchRequest(
                        keyword: searchQuery,
                        page: page,
                        sortOption: input.sortOptionSelectEvent.value(),
                        color: input.colorOptionSelectEvent.value()
                    )
                ) { result in
                    switch result {
                    case .success(let images):
                        output.searchState.onNext(.result(images))
                    case .failure(let error):
                        Logger.error(error)
                        output.searchState.onNext(.result([]))
                        output.onError.onNext(())
                    }
                    
                }
                output.searchState.onNext(.searching)
            }
            .store(in: &observableBag)
        
        return output
    }
}

extension SearchViewModel {
    struct Input { 
        let searchTextChangeEvent: Observable<String>
        let queryEnterEvent: Observable<String>
        let sortOptionSelectEvent: Observable<SearchSortOption>
        let colorOptionSelectEvent: Observable<SearchColorOption?>
    }
    
    struct Output {
        let searchState: Observable<SearchState>
        let onError: Observable<Void>
    }
    
    enum SearchState {
        case emptyQuery, searching, result([SearchedImage]), none
    }
}

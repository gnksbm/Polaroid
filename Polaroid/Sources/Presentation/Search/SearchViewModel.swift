//
//  SearchViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

final class SearchViewModel: ViewModel {
    private var observableBag = ObservableBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            emptyQuery: Observable<Void>(()),
            searchState: Observable<SearchState>(.none)
        )
        
        input.searchTextChangeEvent
            .bind { searchQuery in
                output.searchState.onNext(.searching)
            }
            .store(in: &observableBag)
        
        return output
    }
}

extension SearchViewModel {
    struct Input { 
        let searchTextChangeEvent: Observable<String>
    }
    
    struct Output { 
        let emptyQuery: Observable<Void>
        let searchState: Observable<SearchState>
    }
    
    enum SearchState {
        case emptyQuery, searching, result([SearchCVItem]), none
    }
}

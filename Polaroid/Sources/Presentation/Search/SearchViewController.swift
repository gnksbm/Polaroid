//
//  SearchViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

import Neat
import SnapKit

final class SearchViewController: BaseViewController, View {
    private var scrollReachedBottomEvent = Observable<Void>(())
    private var observableBag = ObservableBag()
    
    private let searchController = UISearchController().nt.configure {
        $0.searchBar.placeholder(Literal.Search.searchBarPlaceholder)
    }
    
    private lazy var searchColorButtonView = SearchColorButtonView()
    private lazy var imageCollectionView = SearchImageCollectionView(
    ).nt.configure {
        $0.delegate(self)
    }
    
    override init() {
        super.init()
        viewModel = SearchViewModel()
    }
    
    func bind(viewModel: SearchViewModel) {
        let output = viewModel.transform(
            input: SearchViewModel.Input(
                searchTextChangeEvent: searchController.searchBar
                    .searchTextField.textChangeEvent.asObservable()
                    .map { $0.text ?? "" },
                queryEnterEvent: searchController.searchBar.searchTextField
                    .enterEvent.asObservable()
                    .map { $0.text ?? "" },
                scrollReachedBottomEvent: scrollReachedBottomEvent
                    .throttle(period: 3),
                sortOptionSelectEvent: Observable<SearchSortOption>(.latest),
                colorOptionSelectEvent: Observable<SearchColorOption?>(nil)
            )
        )
        
        let collectionViewBGView = UILabel().nt.configure {
            $0.text(Literal.Search.beforeSearchBackground)
                .font(MPDesign.Font.subtitle.with(weight: .bold))
                .textAlignment(.center)
        }
        imageCollectionView.backgroundView = collectionViewBGView
        
        output.searchState
            .bind { [weak self] state in
                guard let self else { return }
                switch state {
                case .emptyQuery:
                    imageCollectionView.applyItem(items: [])
                    collectionViewBGView.text =
                    Literal.Search.beforeSearchBackground
                    imageCollectionView.backgroundView = collectionViewBGView
                    hideProgressView()
                case .searching:
                    showProgressView()
                case .result(let items):
                    imageCollectionView.applyItem(items: items)
                    hideProgressView()
                    if items.isEmpty {
                        collectionViewBGView.text =
                        Literal.Search.emptyResultBackground
                        imageCollectionView.backgroundView = collectionViewBGView
                    } else {
                        imageCollectionView.backgroundView = nil
                    }
                case .nextPage(let items):
                    imageCollectionView.appendItem(items: items)
                    hideProgressView()
                    if items.isEmpty {
                        collectionViewBGView.text =
                        Literal.Search.emptyResultBackground
                        imageCollectionView.backgroundView = collectionViewBGView
                    } else {
                        imageCollectionView.backgroundView = nil
                    }
                case .finalPage, .none:
                    break
                }
            }
            .store(in: &observableBag)
    }
    
    override func configureLayout() {
        [searchColorButtonView, imageCollectionView].forEach {
            view.addSubview($0)
        }
        
        searchColorButtonView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(searchColorButtonView.contentLayoutGuide)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchColorButtonView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    override func configureNavigation() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func configureNavigationTitle() {
        navigationItem.title = Literal.NavigationTitle.search
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >=
            scrollView.contentSize.height - scrollView.bounds.size.height,
           scrollView.contentSize.height > scrollView.bounds.size.height {
            scrollReachedBottomEvent.onNext(())
        }
    }
}

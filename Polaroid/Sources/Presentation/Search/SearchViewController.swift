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
    private var observableBag = ObservableBag()
    
    private let searchController = UISearchController().nt.configure {
        $0.searchBar.placeholder(Literal.Search.searchBarPlaceholder)
    }
    
    private let collectionView = SearchImageCollectionView()
    
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
                    .map { $0.text ?? "" }
            )
        )
        
        let collectionViewBGView = UILabel().nt.configure {
            $0.text(Literal.Search.beforeSearchBackground)
                .font(MPDesign.Font.subtitle.with(weight: .bold))
                .textAlignment(.center)
        }
        collectionView.backgroundView = collectionViewBGView
        
        output.emptyQuery
            .bind { [weak self] _ in
                self?.collectionView.applyItem { _ in
                    []
                }
                collectionViewBGView.text =
                Literal.Search.beforeSearchBackground
                self?.collectionView.backgroundView = collectionViewBGView
            }
            .store(in: &observableBag)
        
        output.searchState
            .bind { [weak self] state in
                guard let self else { return }
                switch state {
                case .emptyQuery:
                    collectionView.applyItem { _ in
                        []
                    }
                    collectionViewBGView.text =
                    Literal.Search.emptyResultBackground
                    collectionView.backgroundView = collectionViewBGView
                    hideProgressView()
                case .searching:
                    showProgressView()
                case .result(let items):
                    collectionView.applyItem { _ in
                        items
                    }
                    hideProgressView()
                    if items.isEmpty {
                        collectionViewBGView.text =
                        Literal.Search.emptyResultBackground
                        collectionView.backgroundView = collectionViewBGView
                    } else {
                        collectionView.backgroundView = nil
                    }
                case .none:
                    break
                }
            }
            .store(in: &observableBag)
    }
    
    override func configureLayout() {
        [collectionView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
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

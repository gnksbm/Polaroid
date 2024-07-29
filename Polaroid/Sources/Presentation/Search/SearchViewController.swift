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
    private var viewWillAppearEvent = Observable<Void>(())
    private var scrollReachedBottomEvent = Observable<Void>(())
    private let didSelectItemEvent = Observable<LikableImage?>(nil)
    private var observableBag = ObservableBag()
    
    private let searchController = UISearchController().nt.configure {
        $0.searchBar.placeholder(Literal.Search.searchBarPlaceholder)
    }
    
    private lazy var sortButton = SortOptionButton<SearchSortOption>()
    
    private lazy var colorButtonView = ColorButtonView()
    
    private lazy var collectionView = LikableCollectionView(
    ).nt.configure {
        $0.delegate(self)
    }
    
    override init() {
        super.init()
        viewModel = SearchViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearEvent.onNext(())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        colorButtonView.addSpacing(length: sortButton.bounds.width)
    }
    
    func bind(viewModel: SearchViewModel) {
        let output = viewModel.transform(
            input: SearchViewModel.Input(
                viewWillAppearEvent: viewWillAppearEvent.skip(1),
                searchTextChangeEvent: searchController.searchBar
                    .searchTextField.textChangeEvent.asObservable()
                    .map { $0.text ?? "" },
                queryEnterEvent: searchController.searchBar.searchTextField
                    .enterEvent.asObservable()
                    .map { $0.text ?? "" },
                scrollReachedBottomEvent: scrollReachedBottomEvent
                    .throttle(period: 3),
                sortOptionSelectEvent: sortButton.sortSelectEvent,
                colorOptionSelectEvent: colorButtonView.colorSelectEvent,
                likeButtonTapEvent: collectionView.likeButtonTapEvent,
                itemSelectEvent: didSelectItemEvent
            )
        )
        
        let collectionViewBGView = UILabel().nt.configure {
            $0.text(Literal.Search.beforeSearchBackground)
                .font(MPDesign.Font.subtitle.with(weight: .bold))
                .textAlignment(.center)
        }
        collectionView.backgroundView = collectionViewBGView
        
        output.searchState
            .bind { [weak self] state in
                guard let self else { return }
                switch state {
                case .emptyQuery:
                    collectionView.applyItem(items: [])
                    collectionViewBGView.text =
                    Literal.Search.beforeSearchBackground
                    collectionView.backgroundView = collectionViewBGView
                    hideProgressView()
                case .searching:
                    showProgressView()
                case .result(let items):
                    collectionView.applyItem(items: items)
                    hideProgressView()
                    if items.isEmpty {
                        collectionViewBGView.text =
                        Literal.Search.emptyResultBackground
                        collectionView.backgroundView = collectionViewBGView
                    } else {
                        collectionView.backgroundView = nil
                    }
                case .finalPage, .none:
                    break
                }
            }
            .store(in: &observableBag)
        
        output.changedImage
            .bind { [weak self] item in
                guard let self,
                      let item else { return }
                collectionView.updateItems([item])
                showToast(message: item.isLiked ? "❤️" : "💔")
            }
            .store(in: &observableBag)
        
        output.startDetailFlow
            .bind { [weak self] image in
                guard let self,
                      let image else { return }
                navigationController?.pushViewController(
                    DetailViewController(data: image),
                    animated: true
                )
            }
            .store(in: &observableBag)
    }
    
    override func configureLayout() {
        [colorButtonView, sortButton, collectionView].forEach {
            view.addSubview($0)
        }
        
        colorButtonView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(colorButtonView.contentLayoutGuide)
        }
        
        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(colorButtonView)
            make.trailing.equalTo(colorButtonView).offset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(colorButtonView.snp.bottom)
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selectedItem =
        (collectionView as? LikableCollectionView)?.getItem(for: indexPath)
        didSelectItemEvent.onNext(selectedItem)
    }
}

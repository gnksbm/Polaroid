//
//  SearchViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Combine
import UIKit

import Neat
import SnapKit

final class SearchViewController: BaseViewController, View {
    private var viewWillAppearEvent = PassthroughSubject<Void, Never>()
    private var scrollReachedBottomEvent = PassthroughSubject<Void, Never>()
    private let didSelectItemEvent = PassthroughSubject<LikableImage, Never>()
    private var cancelBag = CancelBag()
    
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
        viewWillAppearEvent.send(())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        colorButtonView.addSpacing(length: sortButton.bounds.width)
    }
    
    func bind(viewModel: SearchViewModel) {
        let searchTextChangeEvent = CurrentValueSubject<String, Never>("")
        
        searchController.searchBar.searchTextField.textChangeEvent
            .subscribe(searchTextChangeEvent)
            .store(in: &cancelBag)
        
        let output = viewModel.transform(
            input: SearchViewModel.Input(
                viewWillAppearEvent: viewWillAppearEvent.dropFirst()
                    .eraseToAnyPublisher(),
                searchTextChangeEvent: searchTextChangeEvent,
                queryEnterEvent: searchController.searchBar.searchTextField
                    .didEndOnExitEvent,
                scrollReachedBottomEvent: scrollReachedBottomEvent.throttle(
                    for: 3,
                    scheduler: RunLoop.main,
                    latest: false
                ).eraseToAnyPublisher(),
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
            .sink(with: self) { vc, state in
                switch state {
                case .emptyQuery:
                    vc.collectionView.applyItem(items: [])
                    collectionViewBGView.text =
                    Literal.Search.beforeSearchBackground
                    vc.collectionView.backgroundView = collectionViewBGView
                    vc.hideProgressView()
                case .searching:
                    vc.showProgressView()
                case .result(let items):
                    vc.collectionView.applyItem(items: items)
                    vc.hideProgressView()
                    if items.isEmpty {
                        collectionViewBGView.text =
                        Literal.Search.emptyResultBackground
                        vc.collectionView.backgroundView = collectionViewBGView
                    } else {
                        vc.collectionView.backgroundView = nil
                    }
                case .finalPage, .none:
                    break
                }
            }
            .store(in: &cancelBag)
        
        output.changedImage
            .sink(with: self) { vc, item in
                vc.collectionView.updateItems([item])
                vc.showToast(message: item.isLiked ? "❤️" : "💔")
            }
            .store(in: &cancelBag)
        
        output.startDetailFlow
            .sink(with: self) { vc, image in
                vc.navigationController?.pushViewController(
                    DetailViewController(data: image),
                    animated: true
                )
            }
            .store(in: &cancelBag)
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
            scrollReachedBottomEvent.send(())
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if let selectedItem = (collectionView as? LikableCollectionView)?
            .getItem(for: indexPath) {
            didSelectItemEvent.send(selectedItem)
        }
    }
}

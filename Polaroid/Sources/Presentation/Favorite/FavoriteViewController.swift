//
//  FavoriteViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

final class FavoriteViewController: BaseViewController, View {
    private var scrollReachedBottomEvent = Observable<Void>(())
    private var observableBag = ObservableBag()
    
    private lazy var sortButton = SortOptionButton()
    private lazy var colorButtonView = ColorButtonView()
    private lazy var collectionView = LikableCollectionView()
    
    
    override init() {
        super.init()
        viewModel = FavoriteViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        colorButtonView.addSpacing(length: sortButton.bounds.width)
    }
    
    func bind(viewModel: FavoriteViewModel) {
        
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
    
    override func configureNavigationTitle() {
        navigationItem.title = Literal.NavigationTitle.favorite
    }
}

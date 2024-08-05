//
//  FavoriteViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Combine
import UIKit

import Neat
import SnapKit

final class FavoriteViewController: BaseViewController, View {
    private let viewWillAppearEvent = PassthroughSubject<Void, Never>()
    private var cancelBag = CancelBag()
    
    private lazy var sortButton = SortOptionButton<FavoriteSortOption>()
    private lazy var colorButtonView = ColorButtonView()
    private lazy var collectionView = LikableCollectionView()
    
    
    override init() {
        super.init()
        viewModel = FavoriteViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearEvent.send(())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        colorButtonView.addSpacing(length: sortButton.bounds.width)
    }
    
    func bind(viewModel: FavoriteViewModel) {
        let output = viewModel.transform(
            input: FavoriteViewModel.Input(
                viewWillAppearEvent: viewWillAppearEvent,
                sortOptionSelectEvent: sortButton.sortSelectEvent,
                colorOptionSelectEvent: colorButtonView.colorSelectEvent,
                likeButtonTapEvent: collectionView.likeButtonTapEvent, 
                itemSelectEvent: collectionView.didSelectItemEvent
                    .map(with: self) { vc, indexPath in
                        vc.collectionView.getItem(for: indexPath)
                    }
                    .eraseToAnyPublisher()
            )
        )
        
        let collectionViewBGView = UILabel().nt.configure {
            $0.text(Literal.Search.beforeSearchBackground)
                .font(MPDesign.Font.subtitle.with(weight: .bold))
                .textAlignment(.center)
        }
        
        output.images
            .sink(with: self) { vc, images in
                if images.isEmpty {
                    collectionViewBGView.text =
                    Literal.Favorite.emptyResultBackground
                    vc.collectionView.backgroundView = collectionViewBGView
                } else {
                    vc.collectionView.backgroundView = nil
                }
                vc.collectionView.applyItem(items: images)
            }
            .store(in: &cancelBag)
        
        output.removeSuccessed
            .sink(with: self) { vc, _ in
                vc.showToast(message: "💔")
            }
            .store(in: &cancelBag)
        
        output.onError
            .sink(with: self) { vc, _ in
                vc.showToast(message: "오류가 발생했습니다")
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
    
    override func configureNavigationTitle() {
        navigationItem.title = Literal.NavigationTitle.favorite
    }
}

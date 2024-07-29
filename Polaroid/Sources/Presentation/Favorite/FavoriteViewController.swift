//
//  FavoriteViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import UIKit

import Neat
import SnapKit

final class FavoriteViewController: BaseViewController, View {
    private let viewWillAppearEvent = Observable<Void>(())
    private var observableBag = ObservableBag()
    
    private lazy var sortButton = SortOptionButton<FavoriteSortOption>()
    private lazy var colorButtonView = ColorButtonView()
    private lazy var collectionView = LikableCollectionView()
    
    
    override init() {
        super.init()
        viewModel = FavoriteViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearEvent.onNext(())
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
                itemSelectEvent: collectionView.obDidSelectItemEvent
                    .map { [weak self] indexPath in
                        guard let self,
                              let indexPath else { return nil }
                        return collectionView.getItem(for: indexPath)
                    }
            )
        )
        
        let collectionViewBGView = UILabel().nt.configure {
            $0.text(Literal.Search.beforeSearchBackground)
                .font(MPDesign.Font.subtitle.with(weight: .bold))
                .textAlignment(.center)
        }
        
        output.images
            .bind { [weak self] images in
                guard let self else { return }
                if images.isEmpty {
                    collectionViewBGView.text =
                    Literal.Favorite.emptyResultBackground
                    collectionView.backgroundView = collectionViewBGView
                } else {
                    collectionView.backgroundView = nil
                }
                collectionView.applyItem(items: images)
            }
            .store(in: &observableBag)
        
        output.removeSuccessed
            .bind { [weak self] _ in
                self?.showToast(message: "💔")
            }
            .store(in: &observableBag)
        
        output.onError
            .bind { [weak self] _ in
                guard let self else { return }
                showToast(message: "오류가 발생했습니다")
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
    
    override func configureNavigationTitle() {
        navigationItem.title = Literal.NavigationTitle.favorite
    }
}

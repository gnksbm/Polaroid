//
//  RandomViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import UIKit

import SnapKit

final class RandomViewController: BaseViewController, View {
    private let viewDidLoadEvent = Observable<Void>(())
    private let viewWillAppearEvent = Observable<Void>(())
    private var observableBag = ObservableBag()
    
    private let collectionView = RandomCollectionView()
    
    override init() {
        super.init()
        viewModel = RandomViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgressView()
        viewDidLoadEvent.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        viewWillAppearEvent.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func bind(viewModel: RandomViewModel) {
        let output = viewModel.transform(
            input: RandomViewModel.Input(
                viewDidLoadEvent: viewDidLoadEvent,
                viewWillAppearEvent: viewWillAppearEvent,
                itemSelectEvent: collectionView.cellTapEvent,
                likeButtonTapEvent: collectionView.likeButtonTapEvent, 
                pageChangeEvent: collectionView.pageChangeEvent
            )
        )
        
        output.randomImages
            .bind { [weak self] items in
                guard let self else { return }
                collectionView.applyItem(items: items)
                hideProgressView()
            }
            .store(in: &observableBag)
        
        output.onError
            .bind { [weak self] _ in
                guard let self else { return }
                showToast(message: "오류가 발생했습니다")
                hideProgressView()
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
        
        output.changedImage
            .bind { [weak self] randomImage in
                guard let randomImage else { return }
                self?.collectionView.updateItems([randomImage])
            }
            .store(in: &observableBag)
    }
    
    override func configureLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.applyItem(items: [])
    }
}

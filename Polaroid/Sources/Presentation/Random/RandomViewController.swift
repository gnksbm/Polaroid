//
//  RandomViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Combine
import UIKit

import SnapKit

final class RandomViewController: BaseViewController, View {
    private let viewDidLoadEvent = PassthroughSubject<Void, Never>()
    private let viewWillAppearEvent = PassthroughSubject<Void, Never>()
    private var cancelBag = CancelBag()
    
    private let collectionView = RandomCollectionView()
    
    override init() {
        super.init()
        viewModel = RandomViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgressView()
        viewDidLoadEvent.send(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        viewWillAppearEvent.send(())
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
                likeButtonTapEvent: collectionView.likeButtonTapEvent
            )
        )
        
        output.randomImages
            .withUnretained(self)
            .sink { vc, items in
                vc.collectionView.applyItem(items: items)
                vc.hideProgressView()
            }
            .store(in: &cancelBag)
        
        output.onError
            .withUnretained(self)
            .sink { vc, _ in
                vc.showToast(message: "오류가 발생했습니다")
                vc.hideProgressView()
            }
            .store(in: &cancelBag)
        
        output.startDetailFlow
            .withUnretained(self)
            .sink { vc, image in
                vc.navigationController?.pushViewController(
                    DetailViewController(data: image),
                    animated: true
                )
            }
            .store(in: &cancelBag)
        
        output.changedImage
            .withUnretained(self)
            .sink { vc, randomImage in
                vc.collectionView.updateItems([randomImage])
                vc.showToast(message: randomImage.isLiked ? "❤️" : "💔")
            }
            .store(in: &cancelBag)
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

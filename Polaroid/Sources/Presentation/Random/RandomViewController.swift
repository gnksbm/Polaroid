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
        
        cancelBag.insert {
            output.randomImages
                .sink(with: self) { vc, items in
                    vc.collectionView.applyItem(items: items)
                    vc.hideProgressView()
                }
            
            output.onError
                .sink(with: self) { vc, _ in
                    vc.showToast(message: "오류가 발생했습니다")
                    vc.hideProgressView()
                }
            
            output.startDetailFlow
                .sink(with: self) { vc, image in
                    vc.navigationController?.pushViewController(
                        DetailViewController(data: image),
                        animated: true
                    )
                }
            
            output.changedImage
                .sink(with: self) { vc, randomImage in
                    vc.collectionView.updateItems([randomImage])
                    vc.showToast(message: randomImage.isLiked ? "❤️" : "💔")
                }
        }
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

//
//  TopicViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import UIKit

import SnapKit

final class TopicViewController: BaseViewController, View {
    private let viewDidLoadEvent = Observable<Void>(())
    private var observableBag = ObservableBag()
    
    private let profileButton = ProfileImageButton(
        type: .static,
        dimension: .width
    )
    private let collectionView = TopicCollectionView()
    
    override init() {
        super.init()
        viewModel = TopicViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadEvent.onNext(())
    }
    
    func bind(viewModel: TopicViewModel) {
        let output = viewModel.transform(
            input: TopicViewModel.Input(
                viewDidLoadEvent: viewDidLoadEvent
            )
        )
        
        output.sectionDatas
            .bind { [weak self] sectionDatas in
                self?.collectionView.applySnapshot(sectionDatas)
            }
            .store(in: &observableBag)
        
        output.onError
            .bind { [weak self] _ in
                self?.showToast(message: "오류가 발생했습니다")
            }
            .store(in: &observableBag)
    }
    
    override func configureLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: profileButton
        )
    }
}

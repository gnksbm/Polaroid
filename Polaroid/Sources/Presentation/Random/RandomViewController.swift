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
    }
    
    func bind(viewModel: RandomViewModel) {
        let output = viewModel.transform(
            input: RandomViewModel.Input(
                viewDidLoadEvent: viewDidLoadEvent
            )
        )
        
        output.randomImages
            .bind { [weak self] items in
                guard let self else { return }
                collectionView.applyItem { section in
                    switch section {
                    case .main:
                        items
                    }
                }
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
    }
    
    override func configureLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.applyItem { section in
            switch section {
            case .main:
                []
            }
        }
    }
}

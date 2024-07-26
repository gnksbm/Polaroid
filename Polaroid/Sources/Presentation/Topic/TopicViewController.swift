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
    private let titleLabel = UILabel().nt.configure {
        $0.text(Literal.NavigationTitle.ourTopic)
            .font(MPDesign.Font.largeNavigationTitle.with(weight: .bold))
    }
    private let collectionView = TopicCollectionView()
    
    override init() {
        super.init()
        viewModel = TopicViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadEvent.onNext(())
        showProgressView()
    }
    
    func bind(viewModel: TopicViewModel) {
        let output = viewModel.transform(
            input: TopicViewModel.Input(
                viewDidLoadEvent: viewDidLoadEvent
            )
        )
        
        output.sectionDatas
            .bind { [weak self] sectionDatas in
                guard let self else { return }
                collectionView.applySnapshot(sectionDatas)
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
        [titleLabel, collectionView].forEach {
            view.addSubview($0)
        }
        
        let padding = 20.f
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.leading.equalTo(safeArea).inset(padding * 0.75)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    override func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: profileButton
        )
    }
}

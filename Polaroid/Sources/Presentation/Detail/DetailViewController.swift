//
//  DetailViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import UIKit

import SnapKit

final class DetailViewController: BaseViewController, View {
    private let viewDidLoadEvent = Observable<Void>(())
    
    private let createInfoView = ImageCreateInfoView()
    private let imageView = UIImageView()
    private lazy var imageInfoView = SummaryView(
        title: "정보",
        infoView: DeclarativeStackView(spacing: 10) {
            imageSizeView
            hitsCountView
            downloadView
        }
    )
    private let imageSizeView = ItemInfoView(title: "크기")
    private let hitsCountView = ItemInfoView(title: "조회수")
    private let downloadView = ItemInfoView(title: "다운로드")
    
    init(imageID: String) {
        super.init()
        viewModel = DetailViewModel(imageID: imageID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadEvent.onNext(())
    }
    
    func bind(viewModel: DetailViewModel) {
        let output = viewModel.transform(
            input: DetailViewModel.Input(
                viewDidLoadEvent: viewDidLoadEvent
            )
        )
    }
    
    override func configureLayout() {
        [createInfoView, imageView, imageInfoView].forEach {
            view.addSubview($0)
        }
        
        createInfoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(createInfoView.snp.bottom)
            make.horizontalEdges.equalTo(safeArea)
        }
        
        imageInfoView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.horizontalEdges.equalTo(safeArea)
        }
    }
}

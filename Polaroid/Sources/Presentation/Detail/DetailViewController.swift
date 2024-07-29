//
//  DetailViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import UIKit

import Neat
import SnapKit

final class DetailViewController: BaseViewController, View {
    private let viewDidLoadEvent = Observable<Void>(())
    private let viewWillAppearEvent = Observable<Void>(())
    private var observableBag = ObservableBag()
    
    private let createInfoView = ImageCreateInfoView().nt.configure {
        $0.textColor(MPDesign.Color.black)
            .imageColor(MPDesign.Color.tint)
    }
    private let imageView = UIImageView().nt.configure {
        $0.contentMode(.scaleAspectFit)
    }
    private lazy var imageInfoView = SummaryView(
        title: "정보",
        infoView: DeclarativeStackView(spacing: 10) {
            imageSizeView
            viewsCountView
            downloadView
        }
    )
    private let imageSizeView = ItemInfoView(title: "크기")
    private let viewsCountView = ItemInfoView(title: "조회수")
    private let downloadView = ItemInfoView(title: "다운로드")
    
    init<T: MinimumImageData>(data: T) {
        super.init()
        viewModel = DetailViewModel(data: data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadEvent.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearEvent.onNext(())
    }
    
    func bind(viewModel: DetailViewModel) {
        let output = viewModel.transform(
            input: DetailViewModel.Input(
                viewDidLoadEvent: viewDidLoadEvent, 
                viewWillAppearEvent: viewWillAppearEvent,
                likeButtonTapEvent: createInfoView.likeButtonTapEvent
                    .map { [weak self] profileImageData in
                        let imageData =
                        self?.imageView.image?.jpegData(compressionQuality: 1)
                        return (imageData, profileImageData)
                    }
            )
        )
        
        output.detailImage
            .bind { [weak self] detailImage in
                self?.updateView(detailImage: detailImage)
            }
            .store(in: &observableBag)
        
        output.changedImage
            .bind { [weak self] detailImage in
                guard let self,
                      let detailImage else { return }
                updateView(detailImage: detailImage)
                showToast(message: detailImage.isLiked ? "❤️" : "💔")
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
        let scrollView = UIScrollView()
        
        view.addSubview(scrollView)
        
        [createInfoView, imageView, imageInfoView].forEach {
            scrollView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
        }
        
        createInfoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(scrollView.contentLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(createInfoView.snp.bottom)
            make.horizontalEdges.equalTo(scrollView.contentLayoutGuide)
        }
        
        imageInfoView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.horizontalEdges.equalTo(scrollView.contentLayoutGuide)
            make.bottom.equalTo(scrollView.contentLayoutGuide)
        }
    }
    
    private func updateView(detailImage: DetailImage?) {
        guard let detailImage else { return }
        var localProfileURL: URL?
        if let localProfilePath = detailImage.creatorProfileImageLocalPath {
            localProfileURL = URL(string: localProfilePath)
        }
        createInfoView.updateView(
            imageURL: detailImage.creatorProfileImageURL,
            localURL: localProfileURL,
            name: detailImage.creatorName,
            date: detailImage.createdAt,
            isLiked: detailImage.isLiked
        )
        if let localURL = detailImage.localURL {
            imageView.load(urlStr: localURL)
        } else {
            imageView.kf.setImage(with: detailImage.imageURL)
        }
        imageView.snp.makeConstraints { make in
            make.height.equalTo(self.imageView.snp.width)
                .multipliedBy(
                    detailImage.imageHeight.f / detailImage.imageWidth.f
                )
        }
        imageSizeView.updateValue(
            "\(detailImage.imageWidth) x \(detailImage.imageHeight)"
        )
        if let views = detailImage.views {
            viewsCountView.updateValue(views.total.formatted())
        }
        if let download = detailImage.download {
            downloadView.updateValue(download.total.formatted())
        }
    }
}

//
//  ProfileImageEditViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import UIKit

import SnapKit

final class ProfileImageViewController: BaseViewController, View {
    private let viewDidLoadEvent = Observable<Void>(())
    private let viewWillDisappearEvent = Observable<Void>(())
    private var observableBag = ObservableBag()
    
    private let profileButton = ProfileImageButton(
        type: .static,
        dimension: .width
    )
    
    private let cameraImageView = UIImageView().nt.configure {
        $0.image(UIImage(systemName: "camera.circle.fill"))
            .contentMode(.scaleAspectFit)
            .backgroundColor(MPDesign.Color.white)
            .layer.borderWidth(3)
            .layer.borderColor(MPDesign.Color.tint.cgColor)
    }
    
    private let collectionView = ProfileImageCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadEvent.onNext(())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraImageView.applyCornerRadius(demension: .width)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearEvent.onNext(())
    }
    
    func bind(viewModel: ProfileImageViewModel) {
        let output = viewModel.transform(
            input: ProfileImageViewModel.Input(
                viewDidLoadEvent: viewDidLoadEvent,
                itemSelectEvent: collectionView.obDidSelectItemEvent
                    .map { [weak self] indexPath in
                        var result: ProfileImageItem?
                        guard let self,
                              let indexPath else { return result }
                        return collectionView.getItem(for: indexPath)
                    },
                viewWillDisappearEvent: viewWillDisappearEvent
            )
        )
        
        output.selectedImage
            .bind { [weak self] image in
                self?.profileButton.setImage(image, for: .normal)
            }
            .store(in: &observableBag)
        
        output.profileImages
            .bind { [weak self] items in
                self?.collectionView.applyItem(items: items)
            }
            .store(in: &observableBag)
    }
    
    override func configureLayout() {
        [profileButton, cameraImageView, collectionView].forEach { 
            view.addSubview($0)
        }
        
        let padding = 20.f
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(safeArea).inset(padding)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea).multipliedBy(0.25)
            make.width.equalTo(profileButton.snp.height)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileButton)
            make.size.equalTo(profileButton.snp.width).multipliedBy(0.3)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(padding)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
}

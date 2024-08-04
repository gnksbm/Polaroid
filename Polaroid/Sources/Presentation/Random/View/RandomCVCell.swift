//
//  RandomCVCell.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

import Neat
import SnapKit
import Kingfisher

struct RandomImageData {
    var item: RandomImage
    let imageData: Data?
    let profileImageData: Data?
}

final class RandomCVCell: BaseCollectionViewCell, RegistrableCellType {
    static func makeRegistration() -> Registration<RandomImage> {
        Registration { cell, indexPath, item in
            cell.imageTask = cell.imageView.kf.setImage(with: item.imageURL)
            cell.createInfoView.updateView(
                imageURL: item.imageURL,
                localURL: nil,
                name: item.creatorName,
                date: item.createdAt, 
                isLiked: item.isLiked
            )
            cell.createInfoView.likeButtonTapEvent
                .sink { profileImageData in
                    cell.likeButtonTapEvent.onNext(
                        RandomImageData(
                            item: item,
                            imageData: cell.imageView.image?
                                .jpegData(compressionQuality: 1),
                            profileImageData: profileImageData
                        )
                    )
                }
                .store(in: &cell.cancelBag)
        }
    }
    
    let likeButtonTapEvent = Observable<RandomImageData?>(nil)
    var observableBag = ObservableBag()
    var cancelBag = CancelBag()
    
    private var imageTask: DownloadTask?
    
    private let imageView = UIImageView().nt.configure {
        $0.contentMode(.scaleAspectFill)
    }
    
    private let createInfoView = ImageCreateInfoView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        observableBag.cancel()
        cancelBag.cancel()
        imageView.image = nil
        imageTask?.cancel()
        imageTask = nil
    }
    
    override func configureLayout() {
        [imageView, createInfoView].forEach {
            contentView.addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        createInfoView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(contentView)
        }
    }
}

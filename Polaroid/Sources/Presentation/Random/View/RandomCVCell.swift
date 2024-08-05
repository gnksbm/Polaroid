//
//  RandomCVCell.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Combine
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
                .map { profileImageData in
                    RandomImageData(
                        item: item,
                        imageData: cell.imageView.image?
                            .jpegData(compressionQuality: 1),
                        profileImageData: profileImageData
                    )
                }
                .subscribe(cell.likeButtonTapEvent)
                .store(in: &cell.cancelBag)
        }
    }
    
    let likeButtonTapEvent = PassthroughSubject<RandomImageData?, Never>()
    var cancelBag = CancelBag()
    
    private var imageTask: DownloadTask?
    
    private let imageView = UIImageView().nt.configure {
        $0.contentMode(.scaleAspectFill)
    }
    
    private let createInfoView = ImageCreateInfoView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
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

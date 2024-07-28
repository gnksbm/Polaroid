//
//  LikableImageCVCell.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

import Kingfisher
import Neat
import SnapKit

struct LikableImageData {
    var item: LikableImage
    let data: Data?
}

final class LikableImageCVCell: BaseCollectionViewCell, RegistrableCellType {
    static func makeRegistration() -> Registration<LikableImage> {
        Registration { cell, indexPath, item in
            if let localURL = item.localURL {
                cell.imageView.load(urlStr: localURL)
            } else {
                cell.imageView.kf.setImage(with: item.imageURL)
            }
            cell.likeCountView.isHidden = item.isLikeCountHidden
            if !item.isLikeCountHidden,
               let likeCount = item.likeCount {
                cell.likeCountView.updateLabel(text: likeCount.formatted())
            }
            cell.likeButton.configuration?.image =
            UIImage(systemName: item.isLiked ? "heart.fill" : "heart")
            cell.likeButton.tapEvent
                .bind { _ in
                    cell.likeButtonTapEvent.onNext(
                        LikableImageData(
                            item: item,
                            data: cell.imageView.image?
                                .jpegData(compressionQuality: 1)
                        )
                    )
                }
                .store(in: &cell.observableBag)
        }
    }
    
    let likeButtonTapEvent = Observable<LikableImageData?>(nil)
    var observableBag = ObservableBag()
    
    private var imageTask: URLSessionTask?
    
    private let imageView = UIImageView().nt.configure {
        $0.contentMode(.scaleAspectFill)
            .backgroundColor(MPDesign.Color.lightGray)
            .clipsToBounds(true)
    }
    
    private let likeCountView = CapsuleView().nt.configure {
        $0.perform {
            $0.setImage(
                UIImage(systemName: "star.fill"),
                tintColor: .yellow
            )
        }
    }
    
    private let likeButton = CircleButton(
        dimension: .width,
        padding: 5
    ).nt.configure {
        $0.backgroundColor(MPDesign.Color.white.withAlphaComponent(0.5))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        observableBag.cancel()
        imageTask?.cancel()
        imageTask = nil
        imageView.image = nil
    }
    
    override func configureLayout() {
        [
            imageView,
            likeCountView,
            likeButton
        ].forEach { contentView.addSubview($0) }
        
        let padding = 10.f
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        likeCountView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(contentView).inset(padding)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(contentView).inset(padding)
        }
    }
}


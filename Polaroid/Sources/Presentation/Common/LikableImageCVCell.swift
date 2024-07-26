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

final class LikableImageCVCell: BaseCollectionViewCell, RegistrableCellType {
    static func makeRegistration() -> Registration<LikableImage> {
        Registration { cell, indexPath, item in
            cell.imageView.kf.setImage(with: item.imageURL)
            cell.heartButton.setImage(
                UIImage(systemName: item.isLiked ? "heart.fill" : "heart"),
                for: .normal
            )
            if let likeCount = item.likeCount {
                cell.likeCountView.updateLabel(text: likeCount.formatted())
            } else {
                cell.likeCountView.isHidden = true
            }
        }
    }
    
    private var imageTask: URLSessionTask?
    
    private let imageView = UIImageView().nt.configure {
        $0.contentMode(.scaleAspectFill)
            .backgroundColor(MPDesign.Color.lightGray)
            .clipsToBounds(true)
    }
    
    private let likeCountView = CapsuleView().nt.configure {
        $0.perform {
            $0.setImage(UIImage(systemName: "star.fill"), tintColor: .yellow)
        }
    }
    
    private let heartButton = CircleButton(dimension: .width).nt.configure {
        $0.backgroundColor(MPDesign.Color.white.withAlphaComponent(0.5))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        imageView.image = nil
    }
    
    override func configureLayout() {
        [
            imageView,
            likeCountView,
            heartButton
        ].forEach { contentView.addSubview($0) }
        
        let padding = 10.f
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        likeCountView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(contentView).inset(padding)
        }
        
        heartButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(contentView).inset(padding)
        }
    }
}


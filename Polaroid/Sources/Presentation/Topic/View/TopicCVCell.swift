//
//  TopicCVCell.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import UIKit

import Kingfisher
import Neat
import SnapKit

final class TopicCVCell: BaseCollectionViewCell, RegistrableCellType {
    static func makeRegistration() -> Registration<TopicImage> {
        Registration { cell, indexPath, item in
            cell.imageView.kf.setImage(with: item.imageURL)
            cell.likeCountView.updateLabel(text: item.likeCount.formatted())
        }
    }
    
    private var imageTask: URLSessionTask?
    
    private let imageView = UIImageView().nt.configure {
        $0.contentMode(.scaleAspectFill)
            .backgroundColor(MPDesign.Color.lightGray)
    }
    
    private let likeCountView = CapsuleView().nt.configure {
        $0.perform {
            $0.setImage(UIImage(systemName: "star.fill"), tintColor: .yellow)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        imageView.image = nil
    }
    
    override func configureLayout() {
        [imageView, likeCountView].forEach { contentView.addSubview($0) }
        
        let padding = 10.f
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        likeCountView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(contentView).inset(padding)
        }
    }
    
    override func configureUI() {
        layer.cornerRadius = MPDesign.CornerRadius.medium
        clipsToBounds = true
    }
}

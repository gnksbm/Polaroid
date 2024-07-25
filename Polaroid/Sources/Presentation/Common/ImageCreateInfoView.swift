//
//  ImageCreateInfoView.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

import Kingfisher
import SnapKit

final class ImageCreateInfoView: BaseView {
    private let creatorImageView = UIImageView()
    private let creatorNameLabel = UILabel()
    private let creatorAtLabel = UILabel()
    private let likeButton = UIButton()
    
    func updateView(item: RandomImage) {
        creatorImageView.kf.setImage(with: item.creatorProfileImageURL)
    }
    
    override func configureLayout() {
        [
            creatorImageView,
            creatorNameLabel,
            creatorAtLabel,
            likeButton
        ].forEach { addSubview($0) }
        
        let padding = 20.f
        
        creatorImageView.snp.makeConstraints { make in
            make.size.equalTo(snp.height)
            make.leading.equalTo(self).offset(padding)
            make.centerY.equalTo(self)
        }
        
        creatorNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(creatorImageView.snp.trailing).offset(padding)
            make.bottom.equalTo(snp.centerY)
        }
        
        creatorAtLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(creatorNameLabel)
            make.top.equalTo(creatorNameLabel).offset(padding / 2)
        }
        
        likeButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(creatorNameLabel.snp.trailing)
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(padding)
        }
    }
}

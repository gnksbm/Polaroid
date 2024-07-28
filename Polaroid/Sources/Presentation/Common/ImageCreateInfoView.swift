//
//  ImageCreateInfoView.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

import Kingfisher
import Neat
import SnapKit

final class ImageCreateInfoView: BaseView {
    private let creatorImageView = UIImageView().nt.configure {
        $0.clipsToBounds(true)
    }
    
    private let creatorNameLabel = UILabel().nt.configure {
        $0.textColor(MPDesign.Color.white)
            .font(MPDesign.Font.body1)
    }
    
    private let createdAtLabel = UILabel().nt.configure {
        $0.textColor(MPDesign.Color.white)
            .font(MPDesign.Font.caption.with(weight: .semibold))
    }
    
    private let likeButton = UIButton().nt.configure {
        $0.configuration(.plain())
            .configuration.image(UIImage(systemName: "heart"))
            .configuration.baseForegroundColor(MPDesign.Color.white)
            .configuration.preferredSymbolConfigurationForImage(
                UIImage.SymbolConfiguration(font: MPDesign.Font.title)
            )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        creatorImageView.applyCornerRadius(demension: .height)
    }
    
    func updateView(item: RandomImage) {
        creatorImageView.kf.setImage(with: item.creatorProfileImageURL)
        creatorNameLabel.text = item.creatorName
        createdAtLabel.text = item.createdAt?.formatted(dateFormat: .createdAt)
    }
    
    override func configureLayout() {
        [
            creatorImageView,
            creatorNameLabel,
            createdAtLabel,
            likeButton
        ].forEach { addSubview($0) }
        
        let padding = 10.f
        
        creatorImageView.snp.makeConstraints { make in
            make.size.equalTo(snp.height).multipliedBy(0.5)
            make.leading.equalTo(self).offset(padding * 2)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.1)
        }
        
        creatorNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(creatorImageView.snp.trailing).offset(padding)
            make.bottom.equalTo(snp.centerY)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(creatorNameLabel)
            make.top.equalTo(creatorNameLabel.snp.bottom).offset(padding / 2)
        }
        
        likeButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(creatorNameLabel.snp.trailing)
                .offset(padding)
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(padding * 2)
        }
    }
}

//
//  ProfileImageCVCell.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Combine
import UIKit

final class ProfileImageCVCell: BaseCollectionViewCell, RegistrableCellType {
    static func makeRegistration() -> Registration<ProfileImageItem> {
        Registration { cell, indexPath, item in
            cell.imageView.image = item.image
            cell.selectedState.send(item.isSelected)
        }
    }
    
    var selectedState = CurrentValueSubject<Bool, Never>(false)
    var cancelBag = CancelBag()
    
    var normalBorderColor: UIColor? { MPDesign.Color.gray }
    
    var selectedBorderColor: UIColor? { MPDesign.Color.tint }
    
    private let imageView = UIImageView().nt.configure {
        $0.contentMode(.scaleAspectFit)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        applyCornerRadius(demension: .width)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelBag.cancel()
    }
    
    override func configureLayout() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    override func configureUI() {
        bindColor()
        clipsToBounds = true
    }
}

extension ProfileImageCVCell: ToggleView {
    func updateView(isSelected: Bool) {
        if isSelected {
            foregroundColor = selectedForegroundColor
            backgroundColor = selectedBackgroundColor
            layer.borderColor = selectedBorderColor?.cgColor
            layer.borderWidth = MPDesign.BorderSize.large
        } else {
            foregroundColor = normalForegroundColor
            backgroundColor = normalBackgroundColor
            layer.borderColor = normalBorderColor?.cgColor
            layer.borderWidth = MPDesign.BorderSize.small
        }
    }
}

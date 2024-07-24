//
//  CapsuleView.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import UIKit

import Neat
import SnapKit

final class CapsuleView: BaseView {
    private let padding = 15.f
    
    private lazy var stackView = DeclarativeStackView(
        axis: .horizontal,
        spacing: padding / 2
    ) {
        imageView
        textLabel
    }
    
    private let imageView = UIImageView().nt.configure {
        $0.preferredSymbolConfiguration(.init(font: MPDesign.Font.caption))
            .isHidden(true)
    }
    
    private let textLabel = UILabel().nt.configure {
        $0.textColor(MPDesign.Color.white)
            .font(MPDesign.Font.caption)
            .textAlignment(.center)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = rect.height / 2
    }
    
    func setImage(_ image: UIImage?, tintColor: UIColor? = nil) {
        imageView.image = image
        imageView.tintColor = tintColor
        imageView.isHidden = false
    }
    
    func updateLabel(text: String) {
        textLabel.text = text
    }
    
    override func configureUI() {
        backgroundColor = MPDesign.Color.darkGray
        clipsToBounds = true
    }
    
    override func configureLayout() {
        [stackView].forEach { addSubview($0) }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self).inset(padding / 2)
            make.horizontalEdges.equalTo(self).inset(padding)
        }
    }
}

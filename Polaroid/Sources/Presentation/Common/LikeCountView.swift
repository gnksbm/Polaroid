//
//  LikeCountView.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import UIKit

import Neat
import SnapKit

final class LikeCountView: BaseView {
    private let starImageView = UIImageView().nt.configure {
        $0.image(UIImage(systemName: "star.fill"))
            .tintColor(.yellow)
            .preferredSymbolConfiguration(.init(font: MPDesign.Font.caption))
    }
    
    private let countLabel = UILabel().nt.configure {
        $0.textColor(MPDesign.Color.white)
            .font(MPDesign.Font.caption)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = rect.height / 2
    }
    
    func updateView(count: Int) {
        countLabel.text = count.formatted()
    }
    
    override func configureUI() {
        backgroundColor = MPDesign.Color.darkGray
        clipsToBounds = true
    }
    
    override func configureLayout() {
        [starImageView, countLabel].forEach { addSubview($0) }
        
        let padding = 12.f
        
        starImageView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self).inset(padding / 2)
            make.leading.equalTo(self).inset(padding)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(starImageView.snp.trailing).offset(padding / 2)
            make.trailing.equalTo(self).inset(padding)
        }
    }
}

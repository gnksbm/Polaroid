//
//  SummaryView.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import UIKit

final class SummaryView<InfoView: UIView>: BaseView {
    private let titleLabel = UILabel().nt.configure {
        $0.font(MPDesign.Font.body1.with(weight: .bold))
    }
    
    private let infoView: InfoView
    
    init(title: String, infoView: InfoView) {
        self.infoView = infoView
        super.init()
        titleLabel.text = title
    }
    
    override func configureLayout() {
        [titleLabel, infoView].forEach { addSubview($0) }
        
        let padding = 20.f
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self).inset(padding)
            make.width.equalTo(self).multipliedBy(0.25)
        }
        
        infoView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self).inset(padding)
            make.leading.equalTo(titleLabel.snp.trailing).offset(padding)
            make.trailing.equalTo(self).inset(padding)
        }
    }
}

//
//  ItemInfoView.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import UIKit

final class ItemInfoView: BaseView {
    private let titleLabel = UILabel().nt.configure {
        $0.font(MPDesign.Font.label1.with(weight: .bold))
    }
    
    private let valueLabel = UILabel().nt.configure {
        $0.font(MPDesign.Font.label2)
    }
    
    init(title: String) {
        super.init()
        titleLabel.text = title
    }
    
    func updateValue(_ value: String) {
        valueLabel.text = value
    }
    
    override func configureLayout() {
        [titleLabel, valueLabel].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.leading.equalTo(self)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalTo(self)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing)
        }
    }
}

//
//  ColorButton.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Combine
import UIKit

import SnapKit

final class ColorButton: BaseButton, ToggleView {
    var selectedState = CurrentValueSubject<Bool, Never>(false)
    var cancelBag = CancelBag()
    
    var normalBackgroundColor: UIColor? { MPDesign.Color.lightGray }
    
    var selectedBackgroundColor: UIColor? { MPDesign.Color.tint }
    
    private let colorView = UIView()
    private let nameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorView.applyCornerRadius(demension: .height)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        applyCornerRadius(demension: .height)
    }
    
    func updateView(option: ColorOption) {
        colorView.backgroundColor = option.color
        nameLabel.text = option.title
    }
    
    override func configureUI() {
        clipsToBounds = true
        bindColor()
    }
    
    override func configureLayout() {
        [colorView, nameLabel].forEach {
            addSubview($0)
        }
        
        let padding = 5.f
        
        colorView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(self).inset(padding)
            make.width.equalTo(colorView.snp.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(colorView.snp.trailing).offset(padding)
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(padding * 3)
        }
    }
}


extension ColorOption {
    var title: String {
        switch self {
        case .black:
            "블랙"
        case .white:
            "화이트"
        case .yellow:
            "옐로우"
        case .red:
            "레드"
        case .purple:
            "퍼플"
        case .green:
            "그린"
        case .blue:
            "블루"
        }
    }
    
    var color: UIColor {
        switch self {
        case .black:
            MPDesign.Color.black
        case .white:
            MPDesign.Color.white
        case .yellow:
            MPDesign.Color.yellow
        case .red:
            MPDesign.Color.red
        case .purple:
            MPDesign.Color.purple
        case .green:
            MPDesign.Color.green
        case .blue:
            MPDesign.Color.blue
        }
    }
}

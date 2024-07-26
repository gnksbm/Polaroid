//
//  SearchColorCVCell.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import UIKit

import SnapKit

final class SearchColorCVCell: BaseCollectionViewCell, RegistrableCellType {
    static func makeRegistration() -> Registration<SearchColorOption> {
        Registration { cell, indexPath, item in
            cell.circleColorView.backgroundColor = item.color
            cell.circleNameLabel.text = item.title
        }
    }
    
    private let circleColorView = UIView()
    private let circleNameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleColorView.applyCornerRadius(demension: .height)
    }
    
    override func configureLayout() {
        [circleColorView, circleNameLabel].forEach {
            contentView.addSubview($0)
        }
        
        let padding = 5.f
        
        circleColorView.snp.makeConstraints { make in
            make.leading.horizontalEdges.equalTo(contentView).inset(padding)
            make.width.equalTo(circleColorView.snp.height)
        }
        
        circleNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(circleColorView.snp.trailing).offset(padding)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(padding * 3)
        }
    }
}

extension SearchColorOption {
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

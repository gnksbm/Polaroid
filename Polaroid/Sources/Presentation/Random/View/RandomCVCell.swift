//
//  RandomCVCell.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

import Neat
import SnapKit

final class RandomCVCell: BaseCollectionViewCell, RegistrableCellType {
    static func makeRegistration() -> Registration<String> {
        Registration { cell, indexPath, item in
            cell.capsuleView.updateLabel(text: item)
        }
    }
    
    private let capsuleView = CapsuleView()
    
    override func configureLayout() {
        [capsuleView].forEach {
            contentView.addSubview($0)
        }
        
        let padding = 20.f
        
        capsuleView.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.safeAreaLayoutGuide)
                .inset(padding)
        }
    }
}

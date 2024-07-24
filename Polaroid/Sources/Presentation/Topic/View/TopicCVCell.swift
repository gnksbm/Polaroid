//
//  TopicCVCell.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import UIKit

final class TopicCVCell: BaseCollectionViewCell, RegistrableCellType {
    static func makeRegistration() -> Registration<String> {
        Registration { cell, indexPath, itemIdentifier in
            
        }
    }
    
    override func configureUI() {
        layer.cornerRadius = MPDesign.CornerRadius.medium
        clipsToBounds = true
    }
}

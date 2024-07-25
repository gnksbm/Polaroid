//
//  SearchCVCell.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

final class SearchCVCell: UICollectionViewCell, RegistrableCellType {
    static func makeRegistration() -> Registration<SearchCVItem> {
        Registration { cell, indexPath, itemIdentifier in
            cell.backgroundColor = .red
        }
    }
}


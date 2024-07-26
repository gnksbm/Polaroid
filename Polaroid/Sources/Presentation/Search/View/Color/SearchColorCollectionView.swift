//
//  SearchColorCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import UIKit

final class SearchColorCollectionView: 
    ModernCollectionView<SingleSection, SearchColorOption, SearchColorCVCell> {
    override class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .estimated(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = .same(size: 5)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .estimated(1),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .same(size: 15)
            return section
        }
    }
    
    override func configureDataSource() {
        super.configureDataSource()
        applyItem(items: Item.allCases)
    }
}

//
//  TopicCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import UIKit

final class TopicCollectionView: 
    ModernCollectionView<String, String, TopicCVCell> {
    override class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/2),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = .same(size: 5)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(2/3)
                ),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .same(size: 10)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
}

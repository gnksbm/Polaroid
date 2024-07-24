//
//  ProfileImageCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import UIKit

final class ProfileImageCollectionView: ModernCollectionView
<ProfileImageSection, ProfileImageItem, ProfileImageCVCell> {
    override class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/4),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = .same(size: 5)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1/4)
                ),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .same(size: 15)
            return section
        }
    }
}

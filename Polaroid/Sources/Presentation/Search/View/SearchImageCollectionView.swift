//
//  SearchImageCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

final class SearchImageCollectionView: ModernCollectionView
<SearchImageCollectionView.SearchCVSection, SearchedImage, SearchImageCVCell> {
    override class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/2),
                    heightDimension: .fractionalHeight(1)
                )
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(2/3)
                ),
                subitems: [item]
            )
            group.interItemSpacing = .fixed(5)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 5
            return section
        }
    }
}

extension SearchImageCollectionView {
    enum SearchCVSection: CaseIterable {
        case main
    }
}

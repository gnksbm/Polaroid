//
//  SearchImageCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

final class SearchImageCollectionView: ModernCollectionView
<SearchImageCollectionView.SearchCVSection, SearchCVItem, SearchImageCVCell> {
    override class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { section, _ in
            switch Section.allCases[section] {
            case .color:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .estimated(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(1/5)
                    ),
                    subitems: [item]
                )
                group.interItemSpacing = .fixed(5)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .same(size: 10)
                return section
            case .image:
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
}

extension SearchImageCollectionView {
    enum SearchCVSection: CaseIterable {
        case color, image
    }
}

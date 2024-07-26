//
//  TopicCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import UIKit

final class TopicCollectionView: 
    ModernCollectionView<TopicSection, TopicImage, TopicCVCell> {
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
            let sectionInset = 10.f
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: sectionInset,
                bottom: sectionInset,
                trailing: sectionInset
            )
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(10)
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
            ]
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
    
    override init() {
        super.init()
        configureHeader()
        applyItem { section in
            []
        }
    }
    
    private func configureHeader() {
        let headerRegistration = makeHeaderRegistration()
        diffableDataSource.supplementaryViewProvider =
        { collectionView, string, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }
    }
    
    private func makeHeaderRegistration(
    ) -> UICollectionView.SupplementaryRegistration<UICollectionViewCell> {
        UICollectionView.SupplementaryRegistration<UICollectionViewCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { header, _, indexPath in
            var config = UIListContentConfiguration.plainHeader()
            config.attributedText = NSAttributedString(
                string: TopicSection.allCases[indexPath.section].title,
                attributes: [
                    .font: MPDesign.Font.heading.with(weight: .bold),
                    .foregroundColor: MPDesign.Color.black
                ]
            )
            header.contentConfiguration = config
        }
    }
}

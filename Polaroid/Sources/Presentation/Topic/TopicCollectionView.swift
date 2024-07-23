//
//  TopicCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import UIKit

final class TopicCollectionView: 
    ModernCollectionView<TopicSection, String, TopicCVCell> {
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
    
    override init() {
        super.init()
        applySnapshot(with: TopicSection.allCases.map {
            SectionData(section: $0, items: [])
        })
    }}

enum TopicSection: CaseIterable {
    case goldenHour, architectureInterior, businessWork
    
    var title: String {
        switch self {
        case .goldenHour:
            "골든 아워"
        case .architectureInterior:
            "건축 및 인테리어"
        case .businessWork:
            "비즈니스 및 업무"
        }
    }
    
    var requestQuery: String {
        switch self {
        case .goldenHour:
            "golden-hour"
        case .architectureInterior:
            "architecture-interior"
        case .businessWork:
            "business-work"
        }
    }
}

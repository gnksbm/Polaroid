//
//  RandomCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

final class RandomCollectionView: ModernCollectionView<String, String, RandomCVCell> {
    override class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: [item]
            )
            return NSCollectionLayoutSection(group: group)
        }
    }
    
    override init() {
        super.init()
        configureView()
    }
    
    private func configureView() {
        contentInsetAdjustmentBehavior = .never
        isPagingEnabled = true
    }
}

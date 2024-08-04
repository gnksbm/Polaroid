//
//  LikableCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Combine
import UIKit

final class LikableCollectionView: 
    ModernCollectionView<SingleSection, LikableImage, LikableImageCVCell> {
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
    
    let likeButtonTapEvent = CurrentValueSubject<LikableImageData?, Never>(nil)
    
    override init() {
        super.init()
        keyboardDismissMode = .onDrag
    }
    
    override func configureDataSource() {
        let registration = Cell.makeRegistration()
        diffableDataSource = DiffableDataSource(
            collectionView: self
        ) { [weak self] collectionView, indexPath, item in
            guard let self else { return Cell() }
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item
            )
            cell.likeButtonTapEvent
                .subscribe(likeButtonTapEvent)
                .store(in: &cell.cancelBag)
            return cell
        }
    }
}

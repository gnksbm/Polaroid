//
//  DiffableCollectionViewType.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

protocol DiffableCollectionViewType: AnyObject where Item == Cell.Item {
    associatedtype Section: Hashable
    associatedtype Item: Hashable
    associatedtype Cell: RegistrableCellType
    
    typealias DiffableDataSource<Section: Hashable, Item: Hashable> =
    UICollectionViewDiffableDataSource<Section, Item>
    
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<Section, Item>
    
    var diffableDataSource: DiffableDataSource<Section, Item>! { get set }
}

extension DiffableCollectionViewType where Self: UICollectionView {
    func applySnapshot(
        with datas: [SectionData<Section, Item>],
        withAnimating: Bool = true
    ) {
        var snapshot = Snapshot()
        datas.forEach { data in
            snapshot.appendSections([data.section])
            snapshot.appendItems(
                data.items,
                toSection: data.section
            )
        }
        diffableDataSource.apply(
            snapshot,
            animatingDifferences: withAnimating
        )
    }
    
    func appendSnapshot(
        with datas: [SectionData<Section, Item>],
        withAnimating: Bool = true
    ) {
        var snapshot = diffableDataSource.snapshot()
        datas.forEach { data in
            if !snapshot.sectionIdentifiers.contains(data.section) {
                snapshot.appendSections([data.section])
            }
            snapshot.appendItems(
                data.items,
                toSection: data.section
            )
        }
        diffableDataSource.apply(
            snapshot,
            animatingDifferences: withAnimating
        )
    }
    
    func configureDataSource() {
        let registration = Cell.registration
        diffableDataSource = DiffableDataSource(
            collectionView: self
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item
            )
        }
    }
}

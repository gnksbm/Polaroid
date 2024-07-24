//
//  ModernCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

protocol ModernCollectionViewType:
    DiffableCollectionViewType, CompositionalCollectionViewType, AnyObject { }

class ModernCollectionView
<Section: Hashable, Item: Hashable, Cell: RegistrableCellType>:
    UICollectionView, ModernCollectionViewType where Item == Cell.Item {
    class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout.list(
            using: UICollectionLayoutListConfiguration(appearance: .plain)
        )
    }
    
    var diffableDataSource: DiffableDataSource<Section, Item>!
    
    init() {
        super.init(
            frame: .zero,
            collectionViewLayout: Self.createLayout()
        )
        configureDataSource()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getItem(
        for indexPath: IndexPath
    ) -> Item where Section: CaseIterable, Section.AllCases.Index == Int {
        let section = Section.allCases[indexPath.section]
        return diffableDataSource.snapshot(for: section).items[indexPath.row]
    }
}

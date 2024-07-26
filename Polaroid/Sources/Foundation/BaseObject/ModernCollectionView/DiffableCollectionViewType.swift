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

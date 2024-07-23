//
//  RegistrableCellType.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

protocol RegistrableCellType: UICollectionViewCell {
    associatedtype Item: Hashable
    
    typealias Registration<Item> =
    UICollectionView.CellRegistration<Self, Item>
    
    static func makeRegistration() -> Registration<Item>
}

//
//  RegistrableCollectionViewCellType.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

protocol RegistrableCollectionViewCellType: UICollectionViewCell {
    associatedtype Item: Hashable
    
    typealias Registration<Item> =
    UICollectionView.CellRegistration<Self, Item>
    
    static var registration: Registration<Item> { get }
}

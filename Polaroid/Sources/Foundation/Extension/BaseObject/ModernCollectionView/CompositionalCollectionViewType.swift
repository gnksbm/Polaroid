//
//  CompositionalCollectionViewType.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

protocol CompositionalCollectionViewType: AnyObject {
    static func createLayout() -> UICollectionViewCompositionalLayout
}

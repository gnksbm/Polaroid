//
//  Observable+UIKit.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

extension UIButton {
    var tapEvent: ObservableControlEvent<UIButton> {
        ObservableControlEvent(
            control: self,
            event: .touchUpInside
        )
    }
}

extension UITextField {
    var textChangeEvent: ObservableControlEvent<UITextField> {
        ObservableControlEvent(
            control: self,
            event: .editingChanged
        )
    }
}

extension UICollectionView {
    var obDidSelectItemEvent: ObservableCollectionViewDelegateProxy {
        ObservableCollectionViewDelegateProxy(collectionView: self)
    }
}

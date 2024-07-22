//
//  Observable+UIKit.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

protocol ObservableControlEventType { }

extension UIControl: ObservableControlEventType { }

extension ObservableControlEventType where Self: UIButton {
    var tapEvent: ObservableControlEvent<Self> {
        ObservableControlEvent(
            control: self,
            event: .touchUpInside
        )
    }
}

extension ObservableControlEventType where Self: UITextField {
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

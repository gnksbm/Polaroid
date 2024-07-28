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
    
    var enterEvent: ObservableControlEvent<UITextField> {
        ObservableControlEvent(
            control: self,
            event: .editingDidEndOnExit
        )
    }
}

extension UICollectionView {
    var obDidSelectItemEvent: Observable<IndexPath?> {
        ObservableCollectionViewDelegateProxy(collectionView: self)
            .asObservable()
    }
}

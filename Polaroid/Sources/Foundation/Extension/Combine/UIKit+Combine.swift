//
//  UIKit+Combine.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Combine
import UIKit

extension CombineControlCompatible where Self: UIButton {
    var tapEvent: AnyPublisher<Void, Never> {
        publisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
            .eraseToAnyPublisher()
    }
}

extension CombineControlCompatible where Self: UITextField {
    var textChangeEvent: AnyPublisher<String, Never> {
        publisher(for: .editingChanged)
            .compactMap(\.text)
            .eraseToAnyPublisher()
            .eraseToAnyPublisher()
    }
}

extension CombineControlCompatible where Self: UIDatePicker {
    var dateChangeEvent: AnyPublisher<Date, Never> {
        publisher(for: .valueChanged)
            .map(\.date)
            .eraseToAnyPublisher()
            .eraseToAnyPublisher()
    }
}

extension UITableView {
    var didSelectRowEvent: AnyPublisher<IndexPath, Never> {
        UITableViewDelegateProxy(self).eraseToAnyPublisher()
    }
}

extension UICollectionView {
    var didSelectItemEvent: AnyPublisher<IndexPath, Never> {
        UICollectionViewDelegateProxy(self).eraseToAnyPublisher()
    }
}

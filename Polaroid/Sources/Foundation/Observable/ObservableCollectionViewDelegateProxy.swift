//
//  ObservableCollectionViewDelegateProxy.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

final class ObservableCollectionViewDelegateProxy: NSObject {
    let collectionView: UICollectionView
    var handler: ((IndexPath) -> Void)?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func bind(_ block: @escaping (IndexPath) -> Void) {
        handler = block
    }
    
    func asObservable() -> Observable<IndexPath?> {
        let observable = Observable<IndexPath?>(nil)
        handler = { indexPath in
            observable.onNext(indexPath)
        }
        return observable
    }
}

extension ObservableCollectionViewDelegateProxy: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        handler?(indexPath)
    }
}

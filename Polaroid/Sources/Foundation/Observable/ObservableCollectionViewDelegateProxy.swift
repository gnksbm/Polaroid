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
        super.init()
        collectionView.delegate = self
    }
    
    func bind(_ block: @escaping (IndexPath) -> Void) -> Self {
        handler = block
        return self
    }
    
    func asObservable() -> Observable<IndexPath?> {
        let observable = Observable<IndexPath?>(nil)
        bind { indexPath in
            observable.onNext(indexPath)
        }
        .store(in: &observable.eventBag)
        return observable
    }
    
    func store(in bag: inout ObservableBag) {
        bag.insert(self)
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

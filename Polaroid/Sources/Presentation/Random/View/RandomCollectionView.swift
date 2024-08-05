//
//  RandomCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Combine
import UIKit

final class RandomCollectionView: 
    ModernCollectionView<SingleSection, RandomImage, RandomCVCell> {
    override class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: [item]
            )
            return NSCollectionLayoutSection(group: group)
        }
    }
    
    let likeButtonTapEvent = PassthroughSubject<RandomImageData?, Never>()
    let cellTapEvent = PassthroughSubject<RandomImage, Never>()
    private let pageChangeEvent = PassthroughSubject<Int, Never>()
    private var cancelBag = CancelBag()
    
    private let capsuleView = CapsuleView()
    
    override init() {
        super.init()
        configureView()
        configureLayout()
    }
    
    override func configureDataSource() {
        let registration = Cell.makeRegistration()
        diffableDataSource = DiffableDataSource(
            collectionView: self
        ) { [weak self] collectionView, indexPath, item in
            guard let self else { return Cell() }
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item
            )
            cell.likeButtonTapEvent
                .subscribe(likeButtonTapEvent)
                .store(in: &cell.cancelBag)
            return cell
        }
    }
    
    override func applyItem(items: [RandomImage], withAnimating: Bool = true) {
        super.applyItem(items: items, withAnimating: withAnimating)
        cancelBag.cancel()
        capsuleView.updateLabel(
            text: "\(min(1, items.count)) / \(items.count)"
        )
        pageChangeEvent
            .withUnretained(self)
            .sink { view, cellIndex in
                let itemCount =
                view.diffableDataSource.snapshot(for: .main).items.count
                view.capsuleView.updateLabel(
                    text: "\(min(cellIndex + 1, itemCount)) / \(itemCount)"
                )
            }
            .store(in: &cancelBag)
    }
    
    private func configureLayout() {
        [capsuleView].forEach {
            addSubview($0)
        }
        
        let padding = 20.f
        
        capsuleView.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeAreaLayoutGuide).inset(padding)
        }
    }
    
    private func configureView() {
        delegate = self
        contentInsetAdjustmentBehavior = .never
        isPagingEnabled = true
    }
}

extension RandomCollectionView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if let selectedItem = 
            (collectionView as? Self)?.getItem(for: indexPath) {
            cellTapEvent.send(selectedItem)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellIndex =
        Int(scrollView.contentOffset.y / scrollView.bounds.height)
        pageChangeEvent.send(currentCellIndex)
    }
}

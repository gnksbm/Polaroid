//
//  RandomCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

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
    
    let likeButtonTapEvent = Observable<RandomImageData?>(nil)
    let pageChangeEvent = Observable<Int>(0)
    let cellTapEvent = Observable<RandomImage?>(nil)
    
    private let cellPagingEvent = Observable<Int>(0)
    private var observableBag = ObservableBag()
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
                .bind(to: likeButtonTapEvent)
                .store(in: &cell.observableBag)
            return cell
        }
    }
    
    override func applyItem(items: [RandomImage], withAnimating: Bool = true) {
        super.applyItem(items: items, withAnimating: withAnimating)
        observableBag.cancel()
        capsuleView.updateLabel(
            text: "\(min(1, items.count)) / \(items.count)"
        )
        cellPagingEvent
            .bind { [weak self] cellIndex in
                guard let self else { return }
                let itemCount =
                diffableDataSource.snapshot(for: .main).items.count
                capsuleView.updateLabel(
                    text: "\(min(cellIndex + 1, itemCount)) / \(itemCount)"
                )
                pageChangeEvent.onNext(min(cellIndex + 1, itemCount))
            }
            .store(in: &observableBag)
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
        let selectedItem = (collectionView as? Self)?.getItem(for: indexPath)
        cellTapEvent.onNext(selectedItem)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellIndex =
        Int(scrollView.contentOffset.y / scrollView.bounds.height)
        cellPagingEvent.onNext(currentCellIndex)
    }
}

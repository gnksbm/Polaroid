//
//  RandomCollectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

enum RandomSection: CaseIterable { case main }

final class RandomCollectionView: 
    ModernCollectionView<RandomSection, RandomImage, RandomCVCell> {
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
    
    private let cellPagingEvent = Observable<Int>(0)
    private var observableBag = ObservableBag()
    private let capsuleView = CapsuleView()
    
    override init() {
        super.init()
        configureView()
        configureLayout()
    }
    
    override func applyItem(
        _ sectionHandler: (RandomSection) -> [RandomImage],
        withAnimating: Bool = true
    ) {
        super.applyItem(sectionHandler)
        observableBag.cancel()
        Section.allCases.forEach { section in
            let itemCount = sectionHandler(section).count
            capsuleView.updateLabel(
                text: "\(min(1, itemCount)) / \(itemCount)"
            )
        }
        cellPagingEvent
            .bind { [weak self] cellIndex in
                guard let self else { return }
                let itemCount =
                diffableDataSource.snapshot(for: .main).items.count
                capsuleView.updateLabel(
                    text: "\(min(cellIndex + 1, itemCount)) / \(itemCount)"
                )
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellIndex =
        Int(scrollView.contentOffset.y / scrollView.bounds.height)
        cellPagingEvent.onNext(currentCellIndex)
    }
}

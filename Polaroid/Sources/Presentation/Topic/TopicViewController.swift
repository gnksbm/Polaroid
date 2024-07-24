//
//  TopicViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import UIKit

import SnapKit

final class TopicViewController: BaseViewController {
    private var observableBag = ObservableBag()
    private let profileButton = ProfileImageButton(
        type: .static,
        dimension: .width
    )
    private let collectionView = TopicCollectionView()
    
    override func configureLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        TopicSection.allCases.forEach { section in
            TopicRepository()
                .fetchTopic(
                    request: TopicRequest(topicID: section.requestQuery)
                )
                .bind { result in
                    switch result {
                    case .success(let minImage):
                        self.collectionView.appendSnapshot(
                            with: [
                                SectionData(section: section, items: minImage)
                            ]
                        )
                    case .failure(let error):
                        dump(error)
                    case .none:
                        print("nil")
                    }
                }
                .store(in: &observableBag)
        }
    }
    
    override func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: profileButton
        )
    }
}

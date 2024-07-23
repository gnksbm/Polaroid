//
//  TopicViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import UIKit

import SnapKit

final class TopicViewController: BaseViewController {
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
    }
    
    override func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: profileButton
        )
    }
}

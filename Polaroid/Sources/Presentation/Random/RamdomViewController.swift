//
//  RamdomViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import UIKit

import SnapKit

final class RamdomViewController: BaseViewController {
    private let collectionView = RandomCollectionView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func configureLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

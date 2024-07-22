//
//  ProfileSettingViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

import Neat
import SnapKit

final class ProfileSettingViewController: BaseViewController, View {
    private var observableBag = ObservableBag()
    
    private let mbtiSelectionView = MBTISelectionView()
    private let doneButton = UIButton.largeBorderedButton(
        title: "완료"
    ).nt.configure {
        $0.isEnabled(false)
    }
    
    override init() {
        super.init()
        viewModel = ProfileSettingViewModel()
    }
    
    func bind(viewModel: ProfileSettingViewModel) {
        let output = viewModel.transform(
            input: ProfileSettingViewModel.Input(
                mbtiSelectEvent: mbtiSelectionView.mbtiSelectEvent
            )
        )
        
        output.doneButtonEnable
            .bind { [weak self] isEnabled in
                self?.doneButton.isEnabled = isEnabled
            }
            .store(in: &observableBag)
    }
    
    override func configureLayout() {
        [mbtiSelectionView, doneButton].forEach { view.addSubview($0) }
        
        let safeArea = view.safeAreaLayoutGuide
        let padding = 20.f
        
        mbtiSelectionView.snp.makeConstraints { make in
            make.center.equalTo(safeArea)
        }
        
        doneButton.snp.makeConstraints { make in
            make.width.equalTo(safeArea).multipliedBy(0.8)
            make.centerX.equalTo(safeArea)
            make.bottom.equalTo(safeArea).inset(padding)
        }
    }
}

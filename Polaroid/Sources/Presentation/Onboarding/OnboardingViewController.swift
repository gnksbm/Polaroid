//
//  OnboardingViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

import Neat
import SnapKit

final class OnboardingViewController: BaseViewController, View {
    private var observableBag = ObservableBag()
    
    private let messageImageView = UIImageView().nt.configure {
        $0.image(UIImage.launchMessage)
            .contentMode(.scaleAspectFit)
    }
    
    private let photoImageView = UIImageView().nt.configure {
        $0.image(UIImage.launchPhoto)
            .contentMode(.scaleAspectFit)
    }
    
    private let nameLabel = UILabel().nt.configure {
        $0.text(Literal.Onboarding.name)
            .font(MPDesign.Font.heading.with(weight: .black))
            .textAlignment(.center)
    }
    
    private let startButton = UIButton.largeBorderedButton(title: "시작하기")
    
    override init() {
        super.init()
        viewModel = OnboardingViewModel()
    }
    
    func bind(viewModel: OnboardingViewModel) {
        let output = viewModel.transform(
            input: OnboardingViewModel.Input(
                startButtonTapEvent: startButton.tapEvent.asObservable()
                    .map { _ in }
            )
        )
        
        output.startProfileFlow
            .bind { [weak self] _ in
                self?.navigationController?.pushViewController(
                    ProfileSettingViewController(),
                    animated: true
                )
            }
            .store(in: &observableBag)
    }
    
    override func configureLayout() {
        [messageImageView, photoImageView, nameLabel, startButton].forEach {
            view.addSubview($0)
        }
        
        let padding = 20.f
        
        messageImageView.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea).inset(padding * 2)
            make.bottom.equalTo(photoImageView.snp.top)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.size.equalTo(safeArea.snp.width)
            make.center.equalTo(safeArea)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom)
            make.centerX.equalTo(safeArea)
        }
        
        startButton.snp.makeConstraints { make in
            make.width.equalTo(safeArea).multipliedBy(0.8)
            make.centerX.equalTo(safeArea)
            make.bottom.equalTo(safeArea).inset(padding)
        }
    }
}

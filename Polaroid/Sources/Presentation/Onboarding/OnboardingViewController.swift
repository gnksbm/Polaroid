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
    private var cancelBag = CancelBag()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func bind(viewModel: OnboardingViewModel) {
        let output = viewModel.transform(
            input: OnboardingViewModel.Input(
                startButtonTapEvent: startButton.tapEvent
            )
        )
        
        output.startProfileFlow
            .withUnretained(self)
            .sink { vc, _ in
                vc.navigationController?.pushViewController(
                    ProfileSettingViewController(),
                    animated: true
                )
            }
            .store(in: &cancelBag)
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

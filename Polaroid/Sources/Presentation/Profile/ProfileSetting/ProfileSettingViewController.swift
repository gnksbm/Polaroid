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
    private var viewDidLoadEvent = Observable<Void>(())
    private var observableBag = ObservableBag()
    
    private let profileImageButton = ProfileImageButton(
        type: .static,
        dimension: .width
    )
    
    private lazy var nicknameTextField = UITextField().nt.configure { 
        $0.attributedPlaceholder(
                NSAttributedString(
                    string: Literal.Nickname.placeholder,
                    attributes: [
                        .foregroundColor: MPDesign.Color.gray,
                        .font: MPDesign.Font.body2.with(weight: .regular)
                    ]
                )
            )
    }
    
    private let textFieldUnderlineView = UIView().nt.configure {
        $0.backgroundColor(MPDesign.Color.lightGray)
    }
    
    private let validationLabel = UILabel().nt.configure {
        $0.font(MPDesign.Font.label1.with(weight: .medium))
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadEvent.onNext(())
    }
    
    func bind(viewModel: ProfileSettingViewModel) {
        let output = viewModel.transform(
            input: ProfileSettingViewModel.Input(
                viewDidLoadEvent: viewDidLoadEvent, 
                profileTapEvent: profileImageButton.tapEvent.asObservable()
                    .map { _ in }, 
                nicknameChangeEvent: nicknameTextField.textChangeEvent
                    .asObservable()
                    .map { $0.text ?? "" },
                mbtiSelectEvent: mbtiSelectionView.mbtiSelectEvent,
                doneButtonTapEvent: doneButton.tapEvent.asObservable()
                    .map { _ in }
            )
        )
        
        output.selectedImage
            .bind { [weak self] image in
                self?.profileImageButton.setImage(image, for: .normal)
            }
            .store(in: &observableBag)
        
        output.startEditProfileFlow
            .bind { [weak self] _ in
                let profileVC = ProfileImageViewController()
                let profileVM = ProfileImageViewModel(
                    selectedImage: self?.profileImageButton.imageView?.image
                )
                profileVM.delegate = viewModel
                profileVC.viewModel = profileVM
                self?.navigationController?.pushViewController(
                    profileVC,
                    animated: true
                )
            }
            .store(in: &observableBag)
        
        output.validationResult
            .bind { [weak self] result in
                var message: String
                switch result {
                case .success(let str):
                    message = str
                    self?.validationLabel.textColor = MPDesign.Color.tint
                case .failure(let str):
                    message = str
                    self?.validationLabel.textColor = MPDesign.Color.red
                case nil:
                    message = ""
                }
                self?.validationLabel.text = message
            }
            .store(in: &observableBag)
        
        output.doneButtonEnable
            .bind { [weak self] isEnabled in
                self?.doneButton.isEnabled = isEnabled
            }
            .store(in: &observableBag)
        
        output.startMainTabFolw
            .bind { [weak self] _ in
                self?.view.window?.rootViewController = .getCurrentRootVC()
            }
            .store(in: &observableBag)
    }
    
    override func configureLayout() {
        [
            profileImageButton,
            nicknameTextField,
            textFieldUnderlineView,
            validationLabel,
            mbtiSelectionView,
            doneButton
        ].forEach { view.addSubview($0) }
        
        let padding = 20.f
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(safeArea).inset(padding)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea).multipliedBy(0.25)
            make.width.equalTo(profileImageButton.snp.height)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(padding)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea).multipliedBy(0.8)
        }
        
        textFieldUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(padding)
            make.centerX.equalTo(safeArea)
            make.horizontalEdges.equalTo(nicknameTextField)
            make.height.equalTo(1)
        }
        
        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldUnderlineView.snp.bottom).offset(padding)
            make.centerX.equalTo(safeArea)
            make.horizontalEdges.equalTo(nicknameTextField)
        }
        
        mbtiSelectionView.snp.makeConstraints { make in
            make.top.equalTo(validationLabel.snp.bottom).offset(padding)
            make.centerX.equalTo(safeArea)
            make.horizontalEdges.equalTo(nicknameTextField)
        }
        
        doneButton.snp.makeConstraints { make in
            make.width.equalTo(safeArea).multipliedBy(0.8)
            make.centerX.equalTo(safeArea)
            make.bottom.equalTo(safeArea).inset(padding)
        }
    }
}

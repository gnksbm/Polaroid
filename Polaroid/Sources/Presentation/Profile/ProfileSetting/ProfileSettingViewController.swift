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
    private var removeAlertTapEvent = Observable<Void>(())
    private var observableBag = ObservableBag()
    private var cancelBag = CancelBag()
    
    private let profileImageButton = ProfileImageButton(
        type: .static,
        dimension: .width
    )
    
    private let cameraImageView = UIImageView().nt.configure {
        $0.image(UIImage(systemName: "camera.circle.fill"))
            .contentMode(.scaleAspectFit)
            .backgroundColor(MPDesign.Color.white)
            .layer.borderWidth(3)
            .layer.borderColor(MPDesign.Color.tint.cgColor)
    }
    
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
        $0.font(MPDesign.Font.caption.with(weight: .medium))
    }
    
    private let mbtiSelectionView = MBTISelectionView()
    private let doneButton = UIButton.largeBorderedButton(
        title: "완료"
    ).nt.configure {
        $0.isEnabled(false)
    }
    private let saveButton = UIButton().nt.configure {
        $0.setTitle("저장", for: .normal)
            .isEnabled(false)
            .setTitleColor(MPDesign.Color.black, for: .normal)
            .setTitleColor(MPDesign.Color.lightGray, for: .disabled)
            .perform {
                $0.titleLabel?.font = MPDesign.Font.label1.with(weight: .bold)
            }
    }
    
    private let removeAccountButton = UIButton().nt.configure {
        $0.isHidden(true)
            .configuration(.plain())
            .configuration.attributedTitle(
                AttributedString(
                    "회원탈퇴",
                    attributes: AttributeContainer([
                        .font: MPDesign.Font.label1,
                        .foregroundColor: MPDesign.Color.tint,
                        .underlineColor: MPDesign.Color.tint,
                        .underlineStyle: NSUnderlineStyle.single.rawValue
                    ])
                )
            )
    }
    
    init(flowType: ProfileSettingViewModel.FlowType = .register) {
        super.init()
        viewModel = ProfileSettingViewModel(flowType: flowType)
        switch flowType {
        case .register:
            saveButton.isHidden = true
        case .edit:
            doneButton.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadEvent.onNext(())
        hideKeaboardOnTap()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraImageView.applyCornerRadius(demension: .width)
    }
    
    func bind(viewModel: ProfileSettingViewModel) {
        let doneButtonTapEvent = doneButton.tapEvent.asObservable()
            .map { _ in }
        saveButton.tapEvent
            .bind { _ in
                doneButtonTapEvent.onNext(())
            }
            .store(in: &observableBag)
        
        let output = viewModel.transform(
            input: ProfileSettingViewModel.Input(
                viewDidLoadEvent: viewDidLoadEvent, 
                profileTapEvent: profileImageButton.tapEvent.asObservable()
                    .map { _ in }, 
                nicknameChangeEvent: nicknameTextField.textChangeEvent
                    .asObservable()
                    .map { $0.text ?? "" },
                mbtiSelectEvent: mbtiSelectionView.mbtiSelectEvent,
                doneButtonTapEvent: doneButtonTapEvent,
                removeAccountButtonTapEvent: removeAccountButton.tapEvent
                    .asObservable().map { _ in }, 
                removeAlertTapEvent: removeAlertTapEvent
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
            .withUnretained(self)
            .sink { vc, isEnabled in
                vc.doneButton.isEnabled = isEnabled
                vc.saveButton.isEnabled = isEnabled
            }
            .store(in: &cancelBag)
        
        output.startMainTabFlow
            .bind { [weak self] _ in
                self?.view.window?.rootViewController = .getCurrentRootVC()
            }
            .store(in: &observableBag)
        
        output.selectedUser
            .bind { [weak self] user in
                guard let self,
                      let user else { return }
                profileImageButton.setImage(
                    UIImage(
                        data: user.profileImageData
                    ),
                    for: .normal
                )
                nicknameTextField.text = user.name
                mbtiSelectionView.updateMBTI(mbti: user.mbti)
            }
            .store(in: &observableBag)
        
        output.finishFlow
            .bind { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &observableBag)
        
        output.showRemoveAccountButton
            .bind { [weak self] _ in
                self?.removeAccountButton.isHidden = false
            }
            .store(in: &observableBag)
        
        output.showRemoveAlert
            .bind { [weak self] _ in
                guard let self else { return }
                showAlert(
                    title: "계정을 삭제하시겠습니까?",
                    actionTitle: "확인"
                ) { _ in
                    self.removeAlertTapEvent.onNext(())
                }
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
            doneButton,
            removeAccountButton,
            cameraImageView
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
            make.width.equalTo(safeArea).multipliedBy(0.85)
        }
        
        textFieldUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(padding / 2)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea).multipliedBy(0.9)
            make.height.equalTo(2)
        }
        
        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldUnderlineView.snp.bottom)
                .offset(padding / 2)
            make.centerX.equalTo(safeArea)
            make.horizontalEdges.equalTo(nicknameTextField)
        }
        
        mbtiSelectionView.snp.makeConstraints { make in
            make.top.equalTo(validationLabel.snp.bottom).offset(padding)
            make.centerX.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea).inset(padding / 2)
        }
        
        removeAccountButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea)
            make.bottom.equalTo(doneButton.snp.top).offset(-padding)
        }
        
        doneButton.snp.makeConstraints { make in
            make.width.equalTo(nicknameTextField)
            make.centerX.equalTo(safeArea)
            make.bottom.equalTo(safeArea).inset(padding)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageButton)
            make.size.equalTo(profileImageButton.snp.width).multipliedBy(0.3)
        }
    }
    
    override func configureNavigation() {
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(customView: saveButton)
    }
}

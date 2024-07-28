//
//  ProfileSettingViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

final class ProfileSettingViewModel: ViewModel {
    private let flowType: FlowType
    
    private let favoriteRepository = FavoriteRepository.shared
    
    private let selectedImage = Observable<UIImage?>(nil)
    private var observableBag = ObservableBag()
    
    init(flowType: FlowType) {
        self.flowType = flowType
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            selectedImage: Observable<UIImage?>(nil), 
            validationResult: Observable<ValidationResult?>(nil),
            startEditProfileFlow: Observable<Void>(()),
            doneButtonEnable: Observable<Bool>(false), 
            startMainTabFlow: Observable<Void>(()), 
            selectedUser: Observable<User?>(nil), 
            finishFlow: Observable<Void>(()), 
            showRemoveAccountButton: Observable<Void>(()), 
            showRemoveAlert: Observable<Void>(())
        )
        
        selectedImage
            .bind(to: output.selectedImage)
            .store(in: &observableBag)
        
        input.viewDidLoadEvent
            .bind { [weak self] _ in
                guard let self else { return }
                switch flowType {
                case .register:
                    selectedImage.onNext(
                        Literal.Image.defaultProfileList.randomElement()
                    )
                case .edit:
                    @UserDefaultsWrapper(key: .user, defaultValue: nil)
                    var user: User?
                    guard let user else { return }
                    selectedImage.onNext(UIImage(data: user.profileImageData))
                    output.selectedUser.onNext(user)
                    output.showRemoveAccountButton.onNext(())
                }
            }
            .store(in: &observableBag)
        
        input.profileTapEvent
            .bind(to: output.startEditProfileFlow)
            .store(in: &observableBag)
        
        input.nicknameChangeEvent
            .bind { [weak self] nickname in
                guard let self else { return }
                do {
                    try nickname.validate(validator: NicknameValidator())
                    let message = Literal.Nickname.validationSuccess
                    output.validationResult.onNext(
                        .success(message)
                    )
                } catch {
                    let message = error.localizedDescription
                    output.validationResult.onNext(
                        .failure(message)
                    )
                }
                output.doneButtonEnable.onNext(
                    requiredInputFilled(
                        nickname: nickname,
                        mbti: input.mbtiSelectEvent.value(),
                        output: output
                    )
                )
            }
            .store(in: &observableBag)
        
        input.mbtiSelectEvent
            .map { [weak self] mbti in
                guard let self else { return false }
                return requiredInputFilled(
                    nickname: input.nicknameChangeEvent.value(),
                    mbti: mbti,
                    output: output
                )
            }
            .bind(to: output.doneButtonEnable)
            .store(in: &observableBag)
        
        input.doneButtonTapEvent
            .bind { [weak self] _ in
                guard let self else { return }
                createUser(input: input, output: output)
            }
            .store(in: &observableBag)
        
        input.removeAccountButtonTapEvent
            .bind { _ in
                output.showRemoveAlert.onNext(())
            }
            .store(in: &observableBag)
        
        input.removeAlertTapEvent
            .bind { [weak self] _ in
                @UserDefaultsWrapper(key: .user, defaultValue: nil)
                var user: User?
                _user.removeValue()
                self?.favoriteRepository.removeAll()
                output.startMainTabFlow.onNext(())
            }
            .store(in: &observableBag)
        
        return output
    }
    
    private func createUser(input: Input, output: Output) {
        @UserDefaultsWrapper(key: .user, defaultValue: nil)
        var user: User?
        guard let imageData = selectedImage.value()?.pngData(),
              let mbti = input.mbtiSelectEvent.value() else { return }
        user = User(
            profileImageData: imageData,
            name: input.nicknameChangeEvent.value(),
            mbti: mbti
        )
        switch flowType {
        case .register:
            output.startMainTabFlow.onNext(())
        case .edit:
            output.finishFlow.onNext(())
        }
    }
    
    private func requiredInputFilled(
        nickname: String,
        mbti: MBTI?,
        output: Output
    ) -> Bool {
        switch output.validationResult.value() {
        case .success:
            switch flowType {
            case .register:
                return !nickname.isEmpty && mbti != nil
            case .edit:
                @UserDefaultsWrapper(key: .user, defaultValue: nil)
                var user: User?
                return !nickname.isEmpty && mbti != nil &&
                nickname != user?.name && mbti != user?.mbti &&
                selectedImage.value()?.pngData() != user?.profileImageData
            }
        default:
            return false
        }
    }
}

extension ProfileSettingViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let profileTapEvent: Observable<Void>
        let nicknameChangeEvent: Observable<String>
        let mbtiSelectEvent: Observable<MBTI?>
        let doneButtonTapEvent: Observable<Void>
        let removeAccountButtonTapEvent: Observable<Void>
        let removeAlertTapEvent: Observable<Void>
    }
    
    struct Output {
        let selectedImage: Observable<UIImage?>
        let validationResult: Observable<ValidationResult?>
        let startEditProfileFlow: Observable<Void>
        let doneButtonEnable: Observable<Bool>
        let startMainTabFlow: Observable<Void>
        let selectedUser: Observable<User?>
        let finishFlow: Observable<Void>
        let showRemoveAccountButton: Observable<Void>
        let showRemoveAlert: Observable<Void>
    }
    
    enum ValidationResult {
        case success(String), failure(String)
    }
    
    enum FlowType {
        case register, edit
    }
}

extension ProfileSettingViewModel: ProfileImageViewModelDelegate {
    func finishedFlow(with: UIImage?) {
        selectedImage.onNext(with)
    }
}

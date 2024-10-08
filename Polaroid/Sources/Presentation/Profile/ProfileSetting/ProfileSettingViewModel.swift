//
//  ProfileSettingViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Combine
import UIKit

final class ProfileSettingViewModel: ViewModel {
    private let flowType: FlowType
    
    private let favoriteRepository = FavoriteRepository.shared
    
    private let selectedImage = CurrentValueSubject<UIImage?, Never>(nil)
    
    init(flowType: FlowType) {
        self.flowType = flowType
    }
    
    func transform(input: Input, cancelBag: inout CancelBag) -> Output {
        let output = Output(
            selectedImage: selectedImage,
            validationResult: CurrentValueSubject(nil),
            startEditProfileFlow: input.profileTapEvent,
            doneButtonEnable: PassthroughSubject(),
            startMainTabFlow: PassthroughSubject(),
            selectedUser: PassthroughSubject(),
            finishFlow: PassthroughSubject(),
            showRemoveAccountButton: PassthroughSubject(),
            showRemoveAlert: input.removeAccountButtonTapEvent
        )
        
        cancelBag.insert {
            input.viewDidLoadEvent
                .sink(with: self) { vm, _ in
                    switch vm.flowType {
                    case .register:
                        vm.selectedImage.send(
                            Literal.Image.defaultProfileList.randomElement()
                        )
                    case .edit:
                        @UserDefaultsWrapper(key: .user, defaultValue: nil)
                        var user: User?
                        guard let user else { return }
                        vm.selectedImage.send(
                            UIImage(data: user.profileImageData)
                        )
                        output.selectedUser.send(user)
                        output.showRemoveAccountButton.send(())
                    }
                }
            
            input.nicknameChangeEvent
                .sink(with: self) { vm, nickname in
                    do {
                        try nickname.validate(validator: NicknameValidator())
                        let message = Literal.Nickname.validationSuccess
                        output.validationResult.send(
                            .success(message)
                        )
                    } catch {
                        let message = error.localizedDescription
                        output.validationResult.send(
                            .failure(message)
                        )
                    }
                    output.doneButtonEnable.send(
                        vm.requiredInputFilled(
                            nickname: nickname,
                            mbti: input.mbtiSelectEvent.value,
                            output: output
                        )
                    )
                }
            
            input.mbtiSelectEvent
                .map(with: self) { vm, mbti in
                    return vm.requiredInputFilled(
                        nickname: input.nicknameChangeEvent.value,
                        mbti: mbti,
                        output: output
                    )
                }
                .subscribe(output.doneButtonEnable)
            
            input.doneButtonTapEvent
                .sink(with: self) { vm, _ in
                    vm.createUser(input: input, output: output)
                }
            
            input.removeAlertTapEvent
                .sink(with: self) { vm, _ in
                    @UserDefaultsWrapper(key: .user, defaultValue: nil)
                    var user: User?
                    _user.removeValue()
                    try? vm.favoriteRepository.removeAll()
                    output.startMainTabFlow.send(())
                }
        }
        
        return output
    }
    
    private func createUser(input: Input, output: Output) {
        @UserDefaultsWrapper(key: .user, defaultValue: nil)
        var user: User?
        guard let imageData = selectedImage.value?.pngData(),
              let mbti = input.mbtiSelectEvent.value else { return }
        user = User(
            profileImageData: imageData,
            name: input.nicknameChangeEvent.value,
            mbti: mbti
        )
        switch flowType {
        case .register:
            output.startMainTabFlow.send(())
        case .edit:
            output.finishFlow.send(())
        }
    }
    
    private func requiredInputFilled(
        nickname: String,
        mbti: MBTI?,
        output: Output
    ) -> Bool {
        switch output.validationResult.value {
        case .success:
            switch flowType {
            case .register:
                return !nickname.isEmpty && mbti != nil
            case .edit:
                @UserDefaultsWrapper(key: .user, defaultValue: nil)
                var user: User?
                return !nickname.isEmpty && mbti != nil &&
                (nickname != user?.name || mbti != user?.mbti ||
                selectedImage.value?.pngData() != user?.profileImageData)
            }
        default:
            return false
        }
    }
}

extension ProfileSettingViewModel {
    struct Input {
        let viewDidLoadEvent: PassthroughSubject<Void, Never>
        let profileTapEvent: AnyPublisher<Void, Never>
        let nicknameChangeEvent: CurrentValueSubject<String, Never>
        let mbtiSelectEvent: CurrentValueSubject<MBTI?, Never>
        let doneButtonTapEvent: AnyPublisher<Void, Never>
        let removeAccountButtonTapEvent: AnyPublisher<Void, Never>
        let removeAlertTapEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let selectedImage: CurrentValueSubject<UIImage?, Never>
        let validationResult: CurrentValueSubject<ValidationResult?, Never>
        let startEditProfileFlow: AnyPublisher<Void, Never>
        let doneButtonEnable: PassthroughSubject<Bool, Never>
        let startMainTabFlow: PassthroughSubject<Void, Never>
        let selectedUser: PassthroughSubject<User, Never>
        let finishFlow: PassthroughSubject<Void, Never>
        let showRemoveAccountButton: PassthroughSubject<Void, Never>
        let showRemoveAlert: AnyPublisher<Void, Never>
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
        selectedImage.send(with)
    }
}

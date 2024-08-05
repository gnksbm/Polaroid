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
    private var cancelBag = CancelBag()
    
    init(flowType: FlowType) {
        self.flowType = flowType
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            selectedImage: PassthroughSubject(),
            validationResult: CurrentValueSubject(nil),
            startEditProfileFlow: PassthroughSubject(),
            doneButtonEnable: PassthroughSubject(),
            startMainTabFlow: PassthroughSubject(),
            selectedUser: PassthroughSubject(),
            finishFlow: PassthroughSubject(),
            showRemoveAccountButton: PassthroughSubject(),
            showRemoveAlert: PassthroughSubject()
        )
        
        selectedImage
            .subscribe(output.selectedImage)
            .store(in: &cancelBag)
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .sink { vm, _ in
                switch vm.flowType {
                case .register:
                    vm.selectedImage.send(
                        Literal.Image.defaultProfileList.randomElement()
                    )
                case .edit:
                    @UserDefaultsWrapper(key: .user, defaultValue: nil)
                    var user: User?
                    guard let user else { return }
                    vm.selectedImage.send(UIImage(data: user.profileImageData))
                    output.selectedUser.send(user)
                    output.showRemoveAccountButton.send(())
                }
            }
            .store(in: &cancelBag)
        
        input.profileTapEvent
            .subscribe(output.startEditProfileFlow)
            .store(in: &cancelBag)
        
        input.nicknameChangeEvent
            .sink { [weak self] nickname in
                guard let self else { return }
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
                    requiredInputFilled(
                        nickname: nickname,
                        mbti: input.mbtiSelectEvent.value,
                        output: output
                    )
                )
            }
            .store(in: &cancelBag)
        
        input.mbtiSelectEvent
            .map { [weak self] mbti in
                guard let self else { return false }
                return requiredInputFilled(
                    nickname: input.nicknameChangeEvent.value,
                    mbti: mbti,
                    output: output
                )
            }
            .subscribe(output.doneButtonEnable)
            .store(in: &cancelBag)
        
        input.doneButtonTapEvent
            .sink { [weak self] _ in
                guard let self else { return }
                createUser(input: input, output: output)
            }
            .store(in: &cancelBag)
        
        input.removeAccountButtonTapEvent
            .sink { _ in
                output.showRemoveAlert.send(())
            }
            .store(in: &cancelBag)
        
        input.removeAlertTapEvent
            .sink { [weak self] _ in
                @UserDefaultsWrapper(key: .user, defaultValue: nil)
                var user: User?
                _user.removeValue()
                try? self?.favoriteRepository.removeAll()
                output.startMainTabFlow.send(())
            }
            .store(in: &cancelBag)
        
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
        let selectedImage: PassthroughSubject<UIImage?, Never>
        let validationResult: CurrentValueSubject<ValidationResult?, Never>
        let startEditProfileFlow: PassthroughSubject<Void, Never>
        let doneButtonEnable: PassthroughSubject<Bool, Never>
        let startMainTabFlow: PassthroughSubject<Void, Never>
        let selectedUser: PassthroughSubject<User, Never>
        let finishFlow: PassthroughSubject<Void, Never>
        let showRemoveAccountButton: PassthroughSubject<Void, Never>
        let showRemoveAlert: PassthroughSubject<Void, Never>
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

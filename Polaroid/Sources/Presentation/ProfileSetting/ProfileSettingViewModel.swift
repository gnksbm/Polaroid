//
//  ProfileSettingViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

final class ProfileSettingViewModel: ViewModel {
    private var observableBag = ObservableBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            selectedImage: Observable<UIImage?>(nil), 
            validationResult: Observable<ValidationResult?>(nil),
            startEditProfileFlow: Observable<Void>(()),
            doneButtonEnable: Observable<Bool>(false), 
            startMainTabFolw: Observable<Void>(())
        )
        
        input.viewDidLoadEvent
            .bind { _ in
                output.selectedImage.onNext(Literal.Image.defaultProfileList.randomElement())
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
                createUser()
                output.startMainTabFolw.onNext(())
            }
            .store(in: &observableBag)
        
        return output
    }
    
    private func createUser() {
        @UserDefaultsWrapper(key: .isJoinedUser, defaultValue: false)
        var isJoinedUser
        isJoinedUser = true
    }
    
    private func requiredInputFilled(
        nickname: String,
        mbti: MBTI?,
        output: Output
    ) -> Bool {
        switch output.validationResult.value() {
        case .success:
            !nickname.isEmpty && mbti != nil
        default:
            false
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
    }
    
    struct Output {
        let selectedImage: Observable<UIImage?>
        let validationResult: Observable<ValidationResult?>
        let startEditProfileFlow: Observable<Void>
        let doneButtonEnable: Observable<Bool>
        let startMainTabFolw: Observable<Void>
    }
    
    enum ValidationResult {
        case success(String), failure(String)
    }
}

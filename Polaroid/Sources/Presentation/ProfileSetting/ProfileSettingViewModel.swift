//
//  ProfileSettingViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation

final class ProfileSettingViewModel: ViewModel {
    private var observableBag = ObservableBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            doneButtonEnable: Observable<Bool>(false)
        )
        
        input.mbtiSelectEvent
            .map { $0 != nil }
            .bind(to: output.doneButtonEnable)
            .store(in: &observableBag)
        
        return output
    }
}

extension ProfileSettingViewModel {
    struct Input {
        let mbtiSelectEvent: Observable<MBTI?>
    }
    
    struct Output {
        let doneButtonEnable: Observable<Bool>
    }
}

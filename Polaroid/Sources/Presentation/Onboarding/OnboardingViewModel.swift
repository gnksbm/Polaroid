//
//  OnboardingViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Combine
import Foundation

final class OnboardingViewModel: ViewModel {
    func transform(input: Input, cancelBag: inout CancelBag) -> Output {
        Output(
            startProfileFlow: input.startButtonTapEvent
        )
    }
}

extension OnboardingViewModel {
    struct Input {
        let startButtonTapEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let startProfileFlow: AnyPublisher<Void, Never>
    }
}

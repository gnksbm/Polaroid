//
//  OnboardingViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation

final class OnboardingViewModel: ViewModel {
    private var observableBag = ObservableBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            startProfileFlow: Observable<Void>(())
        )
        
        input.startButtonTapEvent
            .bind { _ in
                output.startProfileFlow.onNext(())
            }
            .store(in: &observableBag)
        
        return output
    }
}

extension OnboardingViewModel {
    struct Input {
        let startButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let startProfileFlow: Observable<Void>
    }
}

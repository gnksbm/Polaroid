//
//  RandomViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

final class RandomViewModel: ViewModel {
    private var randomRepository = RandomRepository()
    private var observableBag = ObservableBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            randomImages: Observable<[RandomImage]>([]),
            onError: Observable<Void>(())
        )
        
        input.viewDidLoadEvent
            .bind { [weak self] _ in
                guard let self else { return }
                randomRepository.fetchRandom { result in
                    switch result {
                    case .success(let imageList):
                        output.randomImages.onNext(imageList)
                    case .failure(let error):
                        Logger.error(error)
                        output.onError.onNext(())
                    }
                }
            }
            .store(in: &observableBag)
        
        return output
    }
}

extension RandomViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let randomImages: Observable<[RandomImage]>
        let onError: Observable<Void>
    }
}

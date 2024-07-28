//
//  RandomViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

final class RandomViewModel: ViewModel {
    private var randomRepository = RandomRepository()
    private var favoriteRepository = FavoriteRepository()
    
    private var observableBag = ObservableBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            randomImages: Observable<[RandomImage]>([]),
            onError: Observable<Void>(()),
            startDetailFlow: Observable<RandomImage?>(nil)
        )
        
        input.viewDidLoadEvent
            .bind { [weak self] _ in
                guard let self else { return }
                randomRepository.fetchRandom { result in
                    switch result {
                    case .success(let imageList):
                        output.randomImages.onNext(
                            self.favoriteRepository.reConfigureImages(imageList)
                        )
                    case .failure(let error):
                        dump(error)
                        Logger.error(error)
                        output.onError.onNext(())
                    }
                }
            }
            .store(in: &observableBag)
        
        input.itemSelectEvent
            .bind(to: output.startDetailFlow)
            .store(in: &observableBag)
        
        return output
    }
}

extension RandomViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let itemSelectEvent: Observable<RandomImage?>
    }
    
    struct Output {
        let randomImages: Observable<[RandomImage]>
        let onError: Observable<Void>
        let startDetailFlow: Observable<RandomImage?>
    }
}

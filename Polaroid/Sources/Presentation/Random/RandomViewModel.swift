//
//  RandomViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

final class RandomViewModel: ViewModel {
    private var randomRepository = RandomRepository.shared
    private var favoriteRepository = FavoriteRepository.shared
    
    private var observableBag = ObservableBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            randomImages: Observable<[RandomImage]>([]),
            onError: Observable<Void>(()),
            startDetailFlow: Observable<RandomImage?>(nil),
            changedImage: Observable<RandomImage?>(nil)
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
        
        input.likeButtonTapEvent
            .bind { [weak self] randomImage in
                guard let self,
                      let randomImage else { return }
                do {
                    if randomImage.item.isLiked {
                        let newImage =
                        try favoriteRepository.removeImage(randomImage.item)
                        output.changedImage.onNext(newImage)
                    } else {
                        let newImage =
                        try favoriteRepository.saveImage(randomImage)
                        output.changedImage.onNext(newImage)
                    }
                } catch {
                    Logger.error(error)
                    output.onError.onNext(())
                }
            }
            .store(in: &observableBag)
        
        return output
    }
}

extension RandomViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let itemSelectEvent: Observable<RandomImage?>
        let likeButtonTapEvent: Observable<RandomImageData?>
    }
    
    struct Output {
        let randomImages: Observable<[RandomImage]>
        let onError: Observable<Void>
        let startDetailFlow: Observable<RandomImage?>
        let changedImage: Observable<RandomImage?>
    }
}

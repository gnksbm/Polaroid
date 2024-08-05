//
//  RandomViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Combine
import Foundation

final class RandomViewModel: ViewModel {
    private var randomRepository = RandomRepository.shared
    private var favoriteRepository = FavoriteRepository.shared
    
    private var observableBag = ObservableBag()
    private var cancelBag = CancelBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            randomImages: Observable<[RandomImage]>([]),
            onError: Observable<Void>(()),
            startDetailFlow: PassthroughSubject<RandomImage, Never>(),
            changedImage: Observable<RandomImage?>(nil)
        )
        
        input.viewDidLoadEvent
            .bind { [weak self] _ in
                self?.fetchImages(output: output)
            }
            .store(in: &observableBag)
        
        input.viewWillAppearEvent
            .bind { [weak self] _ in
                guard let self else { return }
                if output.randomImages.value().count < 10 {
                    fetchImages(output: output)
                }
                let newImages = favoriteRepository.reConfigureImages(
                    output.randomImages.value()
                )
                output.randomImages.onNext(newImages)
            }
            .store(in: &observableBag)
        
        input.itemSelectEvent
            .subscribe(output.startDetailFlow)
            .store(in: &cancelBag)
        
        input.likeButtonTapEvent
            .sink { [weak self] randomImage in
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
            .store(in: &cancelBag)
        
        return output
    }
    
    private func fetchImages(output: Output) {
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
}

extension RandomViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewWillAppearEvent: Observable<Void>
        let itemSelectEvent: PassthroughSubject<RandomImage, Never>
        let likeButtonTapEvent: PassthroughSubject<RandomImageData?, Never>
    }
    
    struct Output {
        let randomImages: Observable<[RandomImage]>
        let onError: Observable<Void>
        let startDetailFlow: PassthroughSubject<RandomImage, Never>
        let changedImage: Observable<RandomImage?>
    }
}

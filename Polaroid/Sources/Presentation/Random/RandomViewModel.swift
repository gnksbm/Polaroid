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
    
    private var cancelBag = CancelBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            randomImages: CurrentValueSubject([]),
            onError: PassthroughSubject(),
            startDetailFlow: PassthroughSubject(),
            changedImage: PassthroughSubject()
        )
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .sink { vm, _ in
                vm.fetchImages(output: output)
            }
            .store(in: &cancelBag)
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .sink { vm, _ in
                let images = output.randomImages.value
                if images.count < 10 {
                    vm.fetchImages(output: output)
                }
                let newImages = vm.favoriteRepository.reConfigureImages(images)
                output.randomImages.send(newImages)
            }
            .store(in: &cancelBag)
        
        input.itemSelectEvent
            .subscribe(output.startDetailFlow)
            .store(in: &cancelBag)
        
        input.likeButtonTapEvent
            .sink { [weak self] randomImage in
                guard let self,
                      let randomImage else { return }
                do {
                    var newImage: RandomImage
                    if randomImage.item.isLiked {
                        newImage =
                        try favoriteRepository.removeImage(randomImage.item)
                    } else {
                        newImage = try favoriteRepository.saveImage(randomImage)
                    }
                    output.changedImage.send(newImage)
                } catch {
                    Logger.error(error)
                    output.onError.send(())
                }
            }
            .store(in: &cancelBag)
        
        return output
    }
    
    private func fetchImages(output: Output) {
        randomRepository.fetchRandom { result in
            switch result {
            case .success(let imageList):
                output.randomImages.send(
                    self.favoriteRepository.reConfigureImages(imageList)
                )
            case .failure(let error):
                dump(error)
                Logger.error(error)
                output.onError.send(())
            }
        }
    }
}

extension RandomViewModel {
    struct Input {
        let viewDidLoadEvent: PassthroughSubject<Void, Never>
        let viewWillAppearEvent: PassthroughSubject<Void, Never>
        let itemSelectEvent: PassthroughSubject<RandomImage, Never>
        let likeButtonTapEvent: PassthroughSubject<RandomImageData?, Never>
    }
    
    struct Output {
        let randomImages: CurrentValueSubject<[RandomImage], Never>
        let onError: PassthroughSubject<Void, Never>
        let startDetailFlow: PassthroughSubject<RandomImage, Never>
        let changedImage: PassthroughSubject<RandomImage, Never>
    }
}

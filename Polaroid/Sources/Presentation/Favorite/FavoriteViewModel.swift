//
//  FavoriteViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation
import Combine

final class FavoriteViewModel: ViewModel {
    private let favoriteRepository = FavoriteRepository.shared
    
    private var cancelBag = CancelBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            images: PassthroughSubject(),
            removeSuccessed: PassthroughSubject(),
            onError: PassthroughSubject(),
            startDetailFlow: input.itemSelectEvent
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .sink { vm, _ in
                output.images.send(vm.favoriteRepository.fetchImage())
            }
            .store(in: &cancelBag)
        
        input.sortOptionSelectEvent
            .withUnretained(self)
            .sink { vm, sortOption in
                output.images.send(
                    vm.favoriteRepository.fetchImage(with: sortOption)
                )
            }
            .store(in: &cancelBag)
        
        input.colorOptionSelectEvent
            .withUnretained(self)
            .sink { vm, colorOption in
                output.images.send(
                    vm.favoriteRepository.fetchImage(with: colorOption)
                )
            }
            .store(in: &cancelBag)
        
        input.likeButtonTapEvent
            .withUnretained(self)
            .sink { vm, imageData in
                do {
                    _ = try vm.favoriteRepository.removeImage(imageData.item)
                    output.images.send(
                        vm.favoriteRepository.fetchImage()
                    )
                    output.removeSuccessed.send(())
                } catch {
                    output.onError.send(())
                }
            }
            .store(in: &cancelBag)
        
        return output
    }
}

extension FavoriteViewModel {
    struct Input {
        let viewWillAppearEvent: PassthroughSubject<Void, Never>
        let sortOptionSelectEvent:
        CurrentValueSubject<FavoriteSortOption, Never>
        let colorOptionSelectEvent: CurrentValueSubject<ColorOption?, Never>
        let likeButtonTapEvent: PassthroughSubject<LikableImageData, Never>
        let itemSelectEvent: AnyPublisher<LikableImage, Never>
    }
    
    struct Output {
        let images: PassthroughSubject<[LikableImage], Never>
        let removeSuccessed: PassthroughSubject<Void, Never>
        let onError: PassthroughSubject<Void, Never>
        let startDetailFlow: AnyPublisher<LikableImage, Never>
    }
}

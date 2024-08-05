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
    
    private var observableBag = ObservableBag()
    private var cancelBag = CancelBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            images: Observable<[LikableImage]>([]),
            removeSuccessed: Observable<Void>(()),
            onError: Observable<Void>(()),
            startDetailFlow: Observable<LikableImage?>(nil)
        )
        
        input.viewWillAppearEvent
            .bind { [weak self] _ in
                guard let self else { return }
                output.images.onNext(favoriteRepository.fetchImage())
            }
            .store(in: &observableBag)
        
        input.sortOptionSelectEvent
            .withUnretained(self)
            .sink { vm, sortOption in
                output.images.onNext(
                    vm.favoriteRepository.fetchImage(with: sortOption)
                )
            }
            .store(in: &cancelBag)
        
        input.colorOptionSelectEvent
            .sink { [weak self] colorOption in
                guard let self else { return }
                output.images.onNext(
                    favoriteRepository.fetchImage(with: colorOption)
                )
            }
            .store(in: &cancelBag)
        
        input.likeButtonTapEvent
            .withUnretained(self)
            .sink { vm, imageData in
                do {
                    _ = try vm.favoriteRepository.removeImage(imageData.item)
                    output.images.onNext(
                        vm.favoriteRepository.fetchImage()
                    )
                    output.removeSuccessed.onNext(())
                } catch {
                    output.onError.onNext(())
                }
            }
            .store(in: &cancelBag)
        
        input.itemSelectEvent
            .bind(to: output.startDetailFlow)
            .store(in: &observableBag)
        
        return output
    }
}

extension FavoriteViewModel {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let sortOptionSelectEvent: 
        CurrentValueSubject<FavoriteSortOption, Never>
        let colorOptionSelectEvent: CurrentValueSubject<ColorOption?, Never>
        let likeButtonTapEvent: PassthroughSubject<LikableImageData, Never>
        let itemSelectEvent: Observable<LikableImage?>
    }
    
    struct Output {
        let images: Observable<[LikableImage]>
        let removeSuccessed: Observable<Void>
        let onError: Observable<Void>
        let startDetailFlow: Observable<LikableImage?>
    }
}

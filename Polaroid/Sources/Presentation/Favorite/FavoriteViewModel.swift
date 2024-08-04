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
            .bind { [weak self] sortOption in
                guard let self else { return }
                output.images.onNext(
                    favoriteRepository.fetchImage(with: sortOption)
                )
            }
            .store(in: &observableBag)
        
        input.colorOptionSelectEvent
            .sink { [weak self] colorOption in
                guard let self else { return }
                output.images.onNext(
                    favoriteRepository.fetchImage(with: colorOption)
                )
            }
            .store(in: &cancelBag)
        
        input.likeButtonTapEvent
            .bind { [weak self] imageData in
                guard let self,
                      let imageData else { return }
                do {
                    _ = try favoriteRepository.removeImage(imageData.item)
                    output.images.onNext(
                        favoriteRepository.fetchImage()
                    )
                    output.removeSuccessed.onNext(())
                } catch {
                    output.onError.onNext(())
                }
            }
            .store(in: &observableBag)
        
        input.itemSelectEvent
            .bind(to: output.startDetailFlow)
            .store(in: &observableBag)
        
        return output
    }
}

extension FavoriteViewModel {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let sortOptionSelectEvent: Observable<FavoriteSortOption>
        let colorOptionSelectEvent: CurrentValueSubject<ColorOption?, Never>
        let likeButtonTapEvent: Observable<LikableImageData?>
        let itemSelectEvent: Observable<LikableImage?>
    }
    
    struct Output {
        let images: Observable<[LikableImage]>
        let removeSuccessed: Observable<Void>
        let onError: Observable<Void>
        let startDetailFlow: Observable<LikableImage?>
    }
}

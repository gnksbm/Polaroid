//
//  FavoriteViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

final class FavoriteViewModel: ViewModel {
    private let favoriteRepository = FavoriteRepository()
    
    private var observableBag = ObservableBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            images: Observable<[LikableImage]>([]),
            onError: Observable<Void>(())
        )
        
        input.viewDidLoadEvent
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
            .bind { [weak self] colorOption in
                guard let self,
                      let colorOption else { return }
                output.images.onNext(
                    favoriteRepository.fetchImage(with: colorOption)
                )
            }
            .store(in: &observableBag)
        
        return output
    }
}

extension FavoriteViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let sortOptionSelectEvent: Observable<FavoriteSortOption>
        let colorOptionSelectEvent: Observable<ColorOption?>
        let likeButtonTapEvent: Observable<LikableImageData?>
    }
    
    struct Output {
        let images: Observable<[LikableImage]>
        let onError: Observable<Void>
    }
}

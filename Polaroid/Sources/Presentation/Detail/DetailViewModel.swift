//
//  DetailViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import Foundation

final class DetailViewModel: ViewModel {
    private var data: MinimumImageData
    
    private let statisticsRepository = StatisticsRepository.shared
    private let favoriteRepository = FavoriteRepository.shared
    
    private var observableBag = ObservableBag()
    
    init<T: MinimumImageData>(data: T) {
        self.data = data
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            detailImage: Observable<DetailImage?>(nil),
            onError: Observable<Void>(())
        )
        
        input.viewDidLoadEvent
            .bind { [weak self] _ in
                guard let self else { return }
                statisticsRepository.fetchStatistics(
                    imageData: data
                ) { result in
                    switch result {
                    case .success(let success):
                        output.detailImage.onNext(
                            self.favoriteRepository.reConfigureImages(success)
                        )
                    case .failure(let error):
                        Logger.error(error)
                        output.onError.onNext(())
                    }
                }
            }
            .store(in: &observableBag)
        
        input.likeButtonTapEvent
            .bind { [weak self] data in
                guard let self,
                      let detailImage = output.detailImage.value()
                else { return }
                do {
                    if detailImage.isLiked {
                        let newImage =
                        try favoriteRepository.removeImage(detailImage)
                        output.detailImage.onNext(newImage)
                    } else {
                        let newImage =
                        try favoriteRepository.saveImage(
                            detailImage,
                            imageData: data.0,
                            profileImageData: data.1
                        )
                        output.detailImage.onNext(newImage)
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

extension DetailViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let likeButtonTapEvent: Observable<(Data?, Data?)>
    }
    
    struct Output {
        let detailImage: Observable<DetailImage?>
        let onError: Observable<Void>
    }
}

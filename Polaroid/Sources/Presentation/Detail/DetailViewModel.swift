//
//  DetailViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import Combine
import Foundation

final class DetailViewModel: ViewModel {
    private var data: MinimumImageData
    
    private let statisticsRepository = StatisticsRepository.shared
    private let favoriteRepository = FavoriteRepository.shared
    
    private var observableBag = ObservableBag()
    private var cancelBag = CancelBag()
    
    init<T: MinimumImageData>(data: T) {
        self.data = data
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            detailImage: Observable<DetailImage?>(nil),
            changedImage: Observable<DetailImage?>(nil),
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
                            self.favoriteRepository.reConfigureImage(success)
                        )
                    case .failure(let error):
                        output.detailImage.onNext(
                            DetailImage(minImageData: self.data)
                        )
                        Logger.error(error)
                    }
                }
            }
            .store(in: &observableBag)
        
        input.viewWillAppearEvent
            .bind { [weak self] _ in
                guard let self,
                      let detailImage = output.detailImage.value()
                else { return }
                let newImage = favoriteRepository.reConfigureImage(detailImage)
                output.detailImage.onNext(newImage)
            }
            .store(in: &observableBag)
        
        input.likeButtonTapEvent
            .withUnretained(self)
            .sink { vm, data in
                guard var detailImage = output.detailImage.value()
                else { return }
                if let currentImage = output.changedImage.value() {
                    detailImage = currentImage
                }
                do {
                    if detailImage.isLiked {
                        let newImage =
                        try vm.favoriteRepository.removeImage(detailImage)
                        output.changedImage.onNext(newImage)
                    } else {
                        let newImage =
                        try vm.favoriteRepository.saveImage(
                            detailImage,
                            imageData: data.0,
                            profileImageData: data.1
                        )
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
}

extension DetailViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewWillAppearEvent: Observable<Void>
        let likeButtonTapEvent: AnyPublisher<(Data?, Data?), Never>
    }
    
    struct Output {
        let detailImage: Observable<DetailImage?>
        let changedImage: Observable<DetailImage?>
        let onError: Observable<Void>
    }
}

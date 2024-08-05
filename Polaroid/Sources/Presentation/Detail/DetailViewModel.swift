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
    
    init<T: MinimumImageData>(data: T) {
        self.data = data
    }
    
    func transform(input: Input, cancelBag: inout CancelBag) -> Output {
        let output = Output(
            detailImage: CurrentValueSubject(nil),
            changedImage: CurrentValueSubject(nil),
            onError: PassthroughSubject()
        )
        
        cancelBag.insert {
            input.viewDidLoadEvent
                .sink { [weak self] _ in
                    guard let self else { return }
                    statisticsRepository.fetchStatistics(
                        imageData: data
                    ) { result in
                        switch result {
                        case .success(let success):
                            output.detailImage.send(
                                self.favoriteRepository.reConfigureImage(
                                    success
                                )
                            )
                        case .failure(let error):
                            output.detailImage.send(
                                DetailImage(minImageData: self.data)
                            )
                            Logger.error(error)
                        }
                    }
                }
            
            input.viewWillAppearEvent
                .sink { [weak self] _ in
                    guard let self,
                          let detailImage = output.detailImage.value
                    else { return }
                    let newImage = favoriteRepository.reConfigureImage(
                        detailImage
                    )
                    output.detailImage.send(newImage)
                }
            
            input.likeButtonTapEvent
                .sink(with: self) { vm, data in
                    guard var detailImage = output.detailImage.value
                    else { return }
                    if let currentImage = output.changedImage.value {
                        detailImage = currentImage
                    }
                    do {
                        if detailImage.isLiked {
                            let newImage =
                            try vm.favoriteRepository.removeImage(detailImage)
                            output.changedImage.send(newImage)
                        } else {
                            let newImage =
                            try vm.favoriteRepository.saveImage(
                                detailImage,
                                imageData: data.0,
                                profileImageData: data.1
                            )
                            output.changedImage.send(newImage)
                        }
                    } catch {
                        Logger.error(error)
                        output.onError.send(())
                    }
                }
        }
        
        return output
    }
}

extension DetailViewModel {
    struct Input {
        let viewDidLoadEvent: PassthroughSubject<Void, Never>
        let viewWillAppearEvent: PassthroughSubject<Void, Never>
        let likeButtonTapEvent: AnyPublisher<(Data?, Data?), Never>
    }
    
    struct Output {
        let detailImage: CurrentValueSubject<DetailImage?, Never>
        let changedImage: CurrentValueSubject<DetailImage?, Never>
        let onError: PassthroughSubject<Void, Never>
    }
}

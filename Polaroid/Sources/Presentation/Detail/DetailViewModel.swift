//
//  DetailViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import Foundation

final class DetailViewModel: ViewModel {
    private let data: MinimumImageData
    
    private let statisticsRepository = StatisticsRepository()
    
    private var observableBag = ObservableBag()
    
    init<T: MinimumImageData>(data: T) {
        self.data = data
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            randomImages: Observable<DetailImage?>(nil),
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
                        output.randomImages.onNext(success)
                    case .failure(let error):
                        Logger.error(error)
                        output.onError.onNext(())
                    }
                }
            }
            .store(in: &observableBag)
        
        return output
    }
}

extension DetailViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let randomImages: Observable<DetailImage?>
        let onError: Observable<Void>
    }
}

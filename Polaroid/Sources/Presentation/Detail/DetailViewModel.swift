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
        let output = Output()
        
        input.viewDidLoadEvent
            .bind { [weak self] _ in
                guard let self else { return }
                statisticsRepository.fetchStatistics(
                    imageData: data
                ) { result in
                    
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
    
    struct Output { }
}

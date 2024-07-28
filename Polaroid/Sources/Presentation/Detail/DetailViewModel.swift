//
//  DetailViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import Foundation

final class DetailViewModel: ViewModel {
    private let imageID: String
    
    private let statisticsRepository = StatisticsRepository()
    
    private var observableBag = ObservableBag()
    
    init(imageID: String) {
        self.imageID = imageID
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .bind { [weak self] _ in
                guard let self else { return }
                statisticsRepository.fetchStatistics(
                    request: StatisticsRequest(imageID: imageID)
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

//
//  DetailViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import Foundation

final class DetailViewModel: ViewModel {
    private let imageID: String
    
    init(imageID: String) {
        self.imageID = imageID
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        return output
    }
}

extension DetailViewModel {
    struct Input { }
    struct Output { }
}

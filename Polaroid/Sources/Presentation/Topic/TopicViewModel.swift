//
//  TopicViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Foundation

final class TopicViewModel: ViewModel {
    private let topicRepository = TopicRepository()
    private var observableBag = ObservableBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            sectionDatas: Observable([]),
            onError: Observable<Void>(())
        )
        
        input.viewDidLoadEvent
            .bind { [weak self] _ in
                guard let self else { return }
                var sectionDatas =
                [SectionData<TopicSection, TopicImage>]()
                let group = DispatchGroup()
                TopicSection.allCases.forEach { section in
                    group.enter()
                    self.topicRepository.fetchTopic(
                        request: TopicRequest(topicID: section.requestQuery)
                    ) { result in
                        switch result {
                        case .success(let minImage):
                            sectionDatas.append(
                                SectionData(section: section, items: minImage)
                            )
                        case .failure(let error):
                            Logger.error(error)
                            output.onError.onNext(())
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    output.sectionDatas.onNext(sectionDatas)
                }
            }
            .store(in: &observableBag)
        
        return output
    }
}

extension TopicViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let sectionDatas: Observable
        <[SectionData<TopicSection, TopicImage>]>
        let onError: Observable<Void>
    }
}

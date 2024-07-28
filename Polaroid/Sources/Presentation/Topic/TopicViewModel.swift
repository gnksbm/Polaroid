//
//  TopicViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Foundation

final class TopicViewModel: ViewModel {
    private let topicRepository = TopicRepository.shared
    private var observableBag = ObservableBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            currentUser: Observable<User?>(nil),
            imageDic: Observable([:]),
            onError: Observable<Void>(()),
            startProfileFlow: Observable<Void>(()),
            startDetailFlow: Observable<TopicImage?>(nil)
        )
        
        input.viewDidLoadEvent
            .bind { [weak self] _ in
                guard let self else { return }
                @UserDefaultsWrapper(key: .user, defaultValue: nil)
                var user: User?
                output.currentUser.onNext(user)
                var itemDic = [TopicSection: [TopicImage]]()
                let group = DispatchGroup()
                TopicSection.allCases.forEach { section in
                    group.enter()
                    self.topicRepository.fetchTopic(
                        request: TopicRequest(topicID: section.requestQuery)
                    ) { result in
                        switch result {
                        case .success(let images):
                            itemDic[section] = images
                        case .failure(let error):
                            Logger.error(error)
                            output.onError.onNext(())
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    output.imageDic.onNext(itemDic)
                }
            }
            .store(in: &observableBag)
        
        input.profileTapEvent
            .bind(to: output.startProfileFlow)
            .store(in: &observableBag)
        
        input.itemSelectEvent
            .bind(to: output.startDetailFlow)
            .store(in: &observableBag)
        
        return output
    }
}

extension TopicViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let profileTapEvent: Observable<Void>
        let itemSelectEvent: Observable<TopicImage?>
    }
    
    struct Output {
        let currentUser: Observable<User?>
        let imageDic: Observable<[TopicSection: [TopicImage]]>
        let onError: Observable<Void>
        let startProfileFlow: Observable<Void>
        let startDetailFlow: Observable<TopicImage?>
    }
}

//
//  TopicViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Combine
import Foundation

final class TopicViewModel: ViewModel {
    private let topicRepository = TopicRepository.shared
    private var cancelBag = CancelBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            currentUser: PassthroughSubject(),
            imageDic: PassthroughSubject(),
            onError: PassthroughSubject(),
            startProfileFlow: PassthroughSubject(),
            startDetailFlow: PassthroughSubject()
        )
        
        input.viewDidLoadEvent
            .sink(with: self) { vm, _ in
                var itemDic = [TopicSection: [TopicImage]]()
                let group = DispatchGroup()
                TopicSection.allCases.forEach { section in
                    group.enter()
                    vm.topicRepository.fetchTopic(
                        request: TopicRequest(topicID: section.requestQuery)
                    ) { result in
                        switch result {
                        case .success(let images):
                            itemDic[section] = images
                        case .failure(let error):
                            Logger.error(error)
                            output.onError.send(())
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    output.imageDic.send(itemDic)
                }
            }
            .store(in: &cancelBag)
        
        input.viewWillAppearEvent
            .sink { _ in
                @UserDefaultsWrapper(key: .user, defaultValue: nil)
                var user: User?
                if let user {
                    output.currentUser.send(user)
                }
            }
            .store(in: &cancelBag)
        
        input.profileTapEvent
            .subscribe(output.startProfileFlow)
            .store(in: &cancelBag)
        
        input.itemSelectEvent
            .subscribe(output.startDetailFlow)
            .store(in: &cancelBag)
        
        return output
    }
}

extension TopicViewModel {
    struct Input {
        let viewDidLoadEvent: PassthroughSubject<Void, Never>
        let viewWillAppearEvent: PassthroughSubject<Void, Never>
        let profileTapEvent: AnyPublisher<Void, Never>
        let itemSelectEvent: AnyPublisher<TopicImage, Never>
    }
    
    struct Output {
        let currentUser: PassthroughSubject<User, Never>
        let imageDic: PassthroughSubject<[TopicSection: [TopicImage]], Never>
        let onError: PassthroughSubject<Void, Never>
        let startProfileFlow: PassthroughSubject<Void, Never>
        let startDetailFlow: PassthroughSubject<TopicImage, Never>
    }
}

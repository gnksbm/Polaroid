//
//  ProfileImageViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Combine
import UIKit

final class ProfileImageViewModel: ViewModel {
    weak var delegate: ProfileImageViewModelDelegate?
    
    private var selectedImage: UIImage?
    
    private var cancelBag = CancelBag()
    
    init(selectedImage: UIImage?) {
        self.selectedImage = selectedImage
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            selectedImage: PassthroughSubject(),
            profileImages: PassthroughSubject()
        )
        
        cancelBag.insert {
            input.viewDidLoadEvent
                .sink(with: self) { vm, _ in
                    vm.setNewOutput(
                        output: output,
                        selectedImage: vm.selectedImage
                    )
                }
            
            input.itemSelectEvent
                .sink(with: self) { vm, item in
                    vm.selectedImage = item.image
                    vm.setNewOutput(
                        output: output,
                        selectedImage: item.image
                    )
                }
            
            input.viewWillDisappearEvent
                .sink(with: self) { vm, _ in
                    vm.delegate?.finishedFlow(with: vm.selectedImage)
                }
        }
        
        return output
    }
    
    private func setNewOutput(
        output: Output,
        selectedImage: UIImage?
    ) {
        let profileImages = [ProfileImageItem](
            images: Literal.Image.defaultProfileList,
            selectedImage: selectedImage
        )
        output.selectedImage.send(selectedImage)
        output.profileImages.send(profileImages)
    }
}

extension ProfileImageViewModel {
    struct Input {
        let viewDidLoadEvent: PassthroughSubject<Void, Never>
        let itemSelectEvent: AnyPublisher<ProfileImageItem, Never>
        let viewWillDisappearEvent: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let selectedImage: PassthroughSubject<UIImage?, Never>
        let profileImages: PassthroughSubject<[ProfileImageItem], Never>
    }
}

protocol ProfileImageViewModelDelegate: AnyObject {
    func finishedFlow(with: UIImage?)
}

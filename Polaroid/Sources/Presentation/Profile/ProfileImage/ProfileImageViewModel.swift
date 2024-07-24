//
//  ProfileImageViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import UIKit

final class ProfileImageViewModel: ViewModel {
    weak var delegate: ProfileImageViewModelDelegate?
    
    private var selectedImage: UIImage?
    
    private var observableBag = ObservableBag()
    
    init(selectedImage: UIImage?) {
        self.selectedImage = selectedImage
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            selectedImage: Observable<UIImage?>(nil),
            sectionData: Observable([])
        )
        
        input.viewDidLoadEvent
            .bind { [weak self] _ in
                guard let self else { return }
                setNewOutput(
                    output: output,
                    selectedImage: selectedImage
                )
            }
            .store(in: &observableBag)
        
        input.itemSelectEvent
            .bind { [weak self] item in
                guard let self else { return }
                selectedImage = item?.image
                setNewOutput(
                    output: output,
                    selectedImage: item?.image
                )
            }
            .store(in: &observableBag)
        
        input.viewWillDisappearEvent
            .bind { [weak self] _ in
                guard let self else { return }
                delegate?.finishedFlow(with: selectedImage)
            }
            .store(in: &observableBag)
        
        return output
    }
    
    private func setNewOutput(
        output: Output,
        selectedImage: UIImage?
    ) {
        let sectionData = ProfileImageSection.allCases.map { section in
            switch section {
            case .main:
                SectionData(
                    section: section,
                    items: .init(
                        images: Literal.Image.defaultProfileList,
                        selectedImage: selectedImage
                    )
                )
            }
        }
        output.selectedImage.onNext(selectedImage)
        output.sectionData.onNext(sectionData)
    }
}

extension ProfileImageViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let itemSelectEvent: Observable<ProfileImageItem?>
        let viewWillDisappearEvent: Observable<Void>
    }
    
    struct Output {
        let selectedImage: Observable<UIImage?>
        let sectionData: Observable
        <[SectionData<ProfileImageSection, ProfileImageItem>]>
    }
}

protocol ProfileImageViewModelDelegate: AnyObject {
    func finishedFlow(with: UIImage?)
}

//
//  MBTIElementSelectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

final class MBTIElementSelectionView
<MBTIElement: MBTIElementType>: BaseStackView {
    let elementSelectEvent = Observable<MBTIElement?>(nil)
    private var observableBag = ObservableBag()
    
    private lazy var buttons = MBTIElement.allCases.map { element in
        MBTIButton(dimension: .width).nt.configure {
            $0.setTitle(element.keyword, for: .normal)
                .perform { button in
                    button.tapEvent.asObservable()
                        .bind { [weak self] button in
                            guard let self else { return }
                            bindButton(sender: button, element: element)
                        }
                        .store(in: &observableBag)
                }
        }
    }
    
    override func configureLayout() {
        axis = .vertical
        spacing = 10
        distribution = .equalSpacing
        
        buttons.forEach { addArrangedSubview($0) }
    }
    
    private func bindButton(sender: MBTIButton, element: MBTIElement) {
        let selectedValue = elementSelectEvent.value()
        if selectedValue == nil {
            sender.selectedState.onNext(true)
            elementSelectEvent.onNext(element)
        } else {
            if selectedValue == element {
                sender.selectedState.onNext(false)
                elementSelectEvent.onNext(nil)
            } else {
                buttons.filter { $0 !== sender }
                    .forEach { button in
                        button.selectedState.onNext(false)
                    }
                sender.selectedState.onNext(true)
                elementSelectEvent.onNext(element)
            }
        }
    }
}

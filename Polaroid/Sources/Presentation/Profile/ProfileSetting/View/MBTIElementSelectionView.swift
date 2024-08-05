//
//  MBTIElementSelectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Combine
import UIKit

final class MBTIElementSelectionView
<MBTIElement: MBTIElementType>: BaseStackView {
    let elementSelectEvent = CurrentValueSubject<MBTIElement?, Never>(nil)
    private var cancelBag = CancelBag()
    
    private lazy var buttons = MBTIElement.allCases.map { element in
        MBTIButton(dimension: .width).nt.configure {
            $0.setTitle(element.keyword, for: .normal)
                .tag(element.rawValue)
                .perform { button in
                    button.tapEvent
                        .map { button }
                        .withUnretained(self)
                        .sink { view, button in
                            view.bindButton(sender: button, element: element)
                        }
                        .store(in: &cancelBag)
                }
        }
    }
    
    override func configureLayout() {
        axis = .vertical
        spacing = 10
        distribution = .equalSpacing
        
        buttons.forEach { addArrangedSubview($0) }
    }
    
    func updateSelection(element: MBTIElement) {
        elementSelectEvent.send(element)
        buttons
            .first { button in
                button.tag == element.rawValue
            }?
            .selectedState.send(true)
    }
    
    private func bindButton(sender: MBTIButton, element: MBTIElement) {
        let selectedValue = elementSelectEvent.value
        if selectedValue == nil {
            sender.selectedState.send(true)
            elementSelectEvent.send(element)
        } else {
            if selectedValue == element {
                sender.selectedState.send(false)
                elementSelectEvent.send(nil)
            } else {
                buttons.filter { $0 !== sender }
                    .forEach { button in
                        button.selectedState.send(false)
                    }
                sender.selectedState.send(true)
                elementSelectEvent.send(element)
            }
        }
    }
}

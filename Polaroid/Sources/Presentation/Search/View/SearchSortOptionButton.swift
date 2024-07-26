//
//  SearchSortOptionButton.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import UIKit

import SnapKit

final class SearchSortOptionButton: BaseButton {
    var sortSelectEvent = Observable<SearchSortOption>(.latest)
    private var observableBag = ObservableBag()
    
    override init() {
        super.init()
        bindButton()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        applyCornerRadius(demension: .height)
    }
    
    override func configureUI() {
        configuration = .filled()
        configuration?.image = UIImage.sort
        configuration?.imagePlacement = .leading
        configuration?.preferredSymbolConfigurationForImage = UIImage
            .SymbolConfiguration(font: MPDesign.Font.body1.with(weight: .bold))
        configuration?.imagePadding = 5
        configuration?.attributedTitle = AttributedString(
            sortSelectEvent.value().title,
            attributes: AttributeContainer([
                .font: MPDesign.Font.body1.with(weight: .bold)
            ])
        )
        configuration?.baseForegroundColor = MPDesign.Color.black
        configuration?.baseBackgroundColor = MPDesign.Color.white
        configuration?.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 20
        )
        layer.borderWidth = 3
        layer.borderColor = MPDesign.Color.lightGray.cgColor
        clipsToBounds = true
    }
    
    private func bindButton() {
        tapEvent
            .bind { [weak self] _ in
                guard let self else { return }
                let options = SearchSortOption.allCases
                if let index = options.firstIndex(of: sortSelectEvent.value()) {
                    let newIndex = options.index(after: index) % options.count
                    let newOption = options[newIndex]
                    sortSelectEvent.onNext(newOption)
                }
            }
            .store(in: &observableBag)
        
        sortSelectEvent
            .bind { [weak self] option in
                self?.configuration?.attributedTitle = AttributedString(
                    option.title,
                    attributes: AttributeContainer([
                        .font: MPDesign.Font.body1.with(weight: .bold)
                    ])
                )
            }
            .store(in: &observableBag)
    }
}

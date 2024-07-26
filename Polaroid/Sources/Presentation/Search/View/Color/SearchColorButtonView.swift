//
//  SearchColorButtonView.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import UIKit

import Neat
import SnapKit

final class SearchColorButtonView: UIScrollView {
    var colorSelectEvent = Observable<SearchColorOption?>(nil)
    private var observableBag = ObservableBag()
    
    private lazy var buttonStackView = DeclarativeStackView(
        axis: .horizontal,
        spacing: 10
    ) {
        SearchColorOption.allCases.map { option in
            SearchColorButton().nt.configure {
                $0.perform { [weak self] in
                    $0.updateView(option: option)
                    self?.bindColorButton($0, option: option)
                }
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        configureView()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        showsHorizontalScrollIndicator = false
    }
    
    private func configureLayout() {
        [buttonStackView].forEach { addSubview($0) }
        
        buttonStackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(10.f)
        }
    }
    
    private func bindColorButton(
        _ sender: SearchColorButton,
        option: SearchColorOption
    ) {
        sender.tapEvent
            .bind { [weak self] colorButton in
                guard let self else { return }
                let selectedColor = colorSelectEvent.value()
                if selectedColor != option {
                    colorSelectEvent.onNext(option)
                } else {
                    colorSelectEvent.onNext(nil)
                }
            }
            .store(in: &observableBag)
        
        colorSelectEvent
            .map { selectedColor in
                selectedColor == option
            }
            .bind(to: sender.selectedState)
            .store(in: &sender.observableBag)
    }
}

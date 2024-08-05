//
//  ColorButtonView.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Combine
import UIKit

import Neat
import SnapKit

final class ColorButtonView: UIScrollView {
    var colorSelectEvent = CurrentValueSubject<ColorOption?, Never>(nil)
    private var cancelBag = CancelBag()
    
    private lazy var buttonStackView = DeclarativeStackView(
        axis: .horizontal,
        spacing: 10
    ) {
        ColorOption.allCases.map { option in
            ColorButton().nt.configure {
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
    
    func addSpacing(length: CGFloat) {
        guard buttonStackView.arrangedSubviews.count <
                ColorOption.allCases.count + 1 else { return }
        let viewLength = length - buttonStackView.spacing * 2
        let spacerView = UIView()
        buttonStackView.addArrangedSubview(spacerView)
        
        spacerView.snp.makeConstraints { make in
            switch buttonStackView.axis {
            case .horizontal:
                make.width.equalTo(viewLength)
            case .vertical:
                make.height.equalTo(viewLength)
            @unknown default:
                break
            }
        }
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
        _ sender: ColorButton,
        option: ColorOption
    ) {
        sender.tapEvent
            .map(with: self) { view, _ in
                let selectedColor = view.colorSelectEvent.value
                if selectedColor != option {
                    return option
                } else {
                    return nil
                }
            }
            .subscribe(colorSelectEvent)
            .store(in: &cancelBag)
        
        colorSelectEvent
            .map { selectedColor in
                selectedColor == option
            }
            .subscribe(sender.selectedState)
            .store(in: &cancelBag)
    }
}

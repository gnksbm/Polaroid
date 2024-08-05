//
//  MBTISelectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Combine
import UIKit

import Neat

final class MBTISelectionView: BaseView {
    let mbtiSelectEvent = CurrentValueSubject<MBTI?, Never>(nil)
    
    private var selectedEnergy: MBTI.Energy? = nil
    private var selectedPerception: MBTI.Perception? = nil
    private var selectedDecisionMaking: MBTI.DecisionMaking? = nil
    private var selectedLifestyle: MBTI.Lifestyle? = nil
    
    private var cancelBag = CancelBag()
    
    private let titleLabel = UILabel().nt.configure {
        $0.text(Literal.MBTI.title)
            .font(MPDesign.Font.body1.with(weight: .bold))
    }
    private let energyView = MBTIElementSelectionView<MBTI.Energy>()
    private let perceptionView = MBTIElementSelectionView<MBTI.Perception>()
    private let decisionMakingView = 
    MBTIElementSelectionView<MBTI.DecisionMaking>()
    private let lifestyleView = MBTIElementSelectionView<MBTI.Lifestyle>()
    
    private lazy var mbtiStackView = DeclarativeStackView(
        axis: .horizontal,
        spacing: 10
    ) {
        energyView
        perceptionView
        decisionMakingView
        lifestyleView
    }
    
    override init() {
        super.init()
        sinkSelectionView()
    }
    
    func updateMBTI(mbti: MBTI) {
        energyView.updateSelection(element: mbti.energy)
        perceptionView.updateSelection(element: mbti.perception)
        decisionMakingView.updateSelection(element: mbti.decisionMaking)
        lifestyleView.updateSelection(element: mbti.lifestyle)
    }
    
    override func configureLayout() {
        [titleLabel, mbtiStackView].forEach { addSubview($0) }
        
        let padding = 20.f
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self).inset(padding)
        }
        
        mbtiStackView.snp.makeConstraints { make in
            make.verticalEdges.lessThanOrEqualTo(self).inset(padding)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing)
                .offset(padding)
            make.trailing.equalTo(self).inset(padding)
        }
    }
    
    private func sinkSelectionView() {
        energyView.elementSelectEvent
            .sink { [weak self] energe in
                self?.selectedEnergy = energe
                self?.setMBTI()
            }
            .store(in: &cancelBag)
        
        perceptionView.elementSelectEvent
            .sink { [weak self] perception in
                self?.selectedPerception = perception
                self?.setMBTI()
            }
            .store(in: &cancelBag)
        
        decisionMakingView.elementSelectEvent
            .sink { [weak self] decisionMaking in
                self?.selectedDecisionMaking = decisionMaking
                self?.setMBTI()
            }
            .store(in: &cancelBag)
        
        lifestyleView.elementSelectEvent
            .sink { [weak self] lifestyle in
                self?.selectedLifestyle = lifestyle
                self?.setMBTI()
            }
            .store(in: &cancelBag)
    }
    
    private func setMBTI() {
        let mbti = MBTI(
            energy: selectedEnergy,
            perception: selectedPerception,
            decisionMaking: selectedDecisionMaking,
            lifestyle: selectedLifestyle
        )
        mbtiSelectEvent.send(mbti)
    }
}

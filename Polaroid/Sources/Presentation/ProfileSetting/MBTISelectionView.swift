//
//  MBTISelectionView.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

import Neat

final class MBTISelectionView: BaseView {
    let mbtiSelectEvent = Observable<MBTI?>(nil)
    
    private var selectedEnergy: MBTI.Energy? = nil
    private var selectedPerception: MBTI.Perception? = nil
    private var selectedDecisionMaking: MBTI.DecisionMaking? = nil
    private var selectedLifestyle: MBTI.Lifestyle? = nil
    
    private var observableBag = ObservableBag()
    
    private let titleLabel = UILabel().nt.configure {
        $0.text(Literal.MBTI.title)
            .font(MPDesign.Font.body1.with(weight: .bold))
    }
    private let energyView = MBTIElementSelectionView<MBTI.Energy>()
    private let perceptionView = MBTIElementSelectionView<MBTI.Perception>()
    private let decisionMakingView = 
    MBTIElementSelectionView<MBTI.DecisionMaking>()
    private let lifestyleView = MBTIElementSelectionView<MBTI.Lifestyle>()
    
    private lazy var mbtiStackView = DeclarativeStackView(axis: .horizontal) {
        energyView
        perceptionView
        decisionMakingView
        lifestyleView
    }
    
    override init() {
        super.init()
        bindSelectionView()
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
    
    private func bindSelectionView() {
        energyView.elementSelectEvent
            .bind { [weak self] energe in
                self?.selectedEnergy = energe
                self?.bindMBTI()
            }
            .store(in: &observableBag)
        
        perceptionView.elementSelectEvent
            .bind { [weak self] perception in
                self?.selectedPerception = perception
                self?.bindMBTI()
            }
            .store(in: &observableBag)
        
        decisionMakingView.elementSelectEvent
            .bind { [weak self] decisionMaking in
                self?.selectedDecisionMaking = decisionMaking
                self?.bindMBTI()
            }
            .store(in: &observableBag)
        
        lifestyleView.elementSelectEvent
            .bind { [weak self] lifestyle in
                self?.selectedLifestyle = lifestyle
                self?.bindMBTI()
            }
            .store(in: &observableBag)
    }
    
    private func bindMBTI() {
        let mbti = MBTI(
            energy: selectedEnergy,
            perception: selectedPerception,
            decisionMaking: selectedDecisionMaking,
            lifestyle: selectedLifestyle
        )
        mbtiSelectEvent.onNext(mbti)
    }
}

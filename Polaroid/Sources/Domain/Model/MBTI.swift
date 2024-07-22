//
//  MBTI.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation

struct MBTI {
    let energy: Energy
    let perception: Perception
    let decisionMaking: DecisionMaking
    let lifestyle: Lifestyle
    
    init(
        energy: Energy,
        perception: Perception,
        decisionMaking: DecisionMaking,
        lifestyle: Lifestyle
    ) {
        self.energy = energy
        self.perception = perception
        self.decisionMaking = decisionMaking
        self.lifestyle = lifestyle
    }
    
    init?(
        energy: Energy?,
        perception: Perception?,
        decisionMaking: DecisionMaking?,
        lifestyle: Lifestyle?
    ) {
        guard let energy,
              let perception,
              let decisionMaking,
              let lifestyle else { return nil }
        self.energy = energy
        self.perception = perception
        self.decisionMaking = decisionMaking
        self.lifestyle = lifestyle
    }
}

protocol MBTIElementType: CaseIterable, Equatable {
    var keyword: String { get }
}

extension MBTI {
    enum Energy: MBTIElementType {
        case introversion, extroversion
        
        var keyword: String {
            switch self {
            case .introversion:
                "I"
            case .extroversion:
                "E"
            }
        }
    }
    
    enum Perception: MBTIElementType {
        case intuition, sensing
        
        var keyword: String {
            switch self {
            case .intuition:
                "N"
            case .sensing:
                "S"
            }
        }
    }
    
    enum DecisionMaking: MBTIElementType {
        case feeling, thinking
        
        var keyword: String {
            switch self {
            case .feeling:
                "F"
            case .thinking:
                "T"
            }
        }
    }
    
    enum Lifestyle: MBTIElementType {
        case perceiving, judging
        
        var keyword: String {
            switch self {
            case .perceiving:
                "P"
            case .judging:
                "J"
            }
        }
    }
}

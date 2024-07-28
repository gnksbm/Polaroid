//
//  MBTI.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation

struct MBTI: Codable, Equatable {
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

protocol MBTIElementType: RawRepresentable<Int>, CaseIterable, Equatable {
    var keyword: String { get }
}

extension MBTI {
    enum Energy: Int, MBTIElementType, Codable {
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
    
    enum Perception: Int, MBTIElementType, Codable {
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
    
    enum DecisionMaking: Int, MBTIElementType, Codable {
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
    
    enum Lifestyle: Int, MBTIElementType, Codable {
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

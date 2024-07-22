//
//  UIButton+.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

import Neat

extension UIButton {
    static func largeBorderedButton(title: String) -> UIButton {
        let inset = 15.f
        return UIButton().nt.configure {
            $0.configuration(.bordered())
                .configuration.cornerStyle(.capsule)
                .configuration.contentInsets(
                    NSDirectionalEdgeInsets(
                        top: inset,
                        leading: 0,
                        bottom: inset,
                        trailing: 0
                    )
                )
                .configuration.attributedTitle(
                    AttributedString(
                        title,
                        attributes: AttributeContainer([
                            .foregroundColor: MPDesign.Color.white,
                            .font: MPDesign.Font.body1.with(weight: .bold)
                        ])
                    )
                )
                .configurationUpdateHandler({ button in
                    switch button.state {
                    case .disabled:
                        button.configuration?.baseBackgroundColor =
                        MPDesign.Color.gray
                    default:
                        button.configuration?.baseBackgroundColor =
                        MPDesign.Color.tint
                    }
                })
        }
    }
    
    static func circleButton(title: String) -> UIButton {
        UIButton().nt.configure { 
            $0.configuration(.bordered())
                .configuration.cornerStyle(.capsule)
                .configuration.attributedTitle(
                    AttributedString(
                        title,
                        attributes: AttributeContainer([
                            .foregroundColor: MPDesign.Color.red,
                            .font: MPDesign.Font.label1
                        ])
                    )
                )
        }
    }
}

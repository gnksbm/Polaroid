//
//  UIWindow+.swift
//  Polaroid
//
//  Created by gnksbm on 7/29/24.
//

import UIKit

extension UIWindow {
    enum OverlayHelper {
        static var warningLabel: UILabel?
        static var warningLabelBottomConstraint: NSLayoutConstraint?
    }
    
    func findCurrentVC() -> UIViewController? {
        guard let rootVC = rootViewController else { return nil }
        if let tabBar = rootVC as? UITabBarController {
            let selectedVC = tabBar.selectedViewController
            if let navController = selectedVC as? UINavigationController {
                return navController.topViewController
            } else {
                return selectedVC
            }
        } else if let navController = rootVC as? UINavigationController {
            return navController.topViewController
        } else {
            return rootVC
        }
    }
    
    func showWarningLabel(message: String) {
        guard OverlayHelper.warningLabel == nil else { return }
        let label = UILabel().nt.configure {
            $0.backgroundColor(MPDesign.Color.red)
                .textColor(MPDesign.Color.white)
                .text(message)
                .alpha(0)
                .textAlignment(.center)
        }
        
        OverlayHelper.warningLabel = label
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            label.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
        ])
        OverlayHelper.warningLabelBottomConstraint = label.topAnchor
            .constraint(equalTo: safeArea.bottomAnchor)
        OverlayHelper.warningLabelBottomConstraint?.isActive = true
        layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.curveEaseIn],
            animations: {
                OverlayHelper.warningLabelBottomConstraint?.constant =
                -label.bounds.height
                label.alpha = 1
            }
        )
    }
    
    func hideWarningLabel(with message: String? = nil) {
        guard let warningLabel = OverlayHelper.warningLabel else { return }
        UIView.transition(
            with: warningLabel,
            duration: 0.3,
            options: .transitionCrossDissolve
        ) {
            if let message {
                warningLabel.text = message
            }
            warningLabel.backgroundColor = MPDesign.Color.green
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.transition(
                with: warningLabel,
                duration: 0.5,
                options: .curveEaseOut,
                animations: {
                    warningLabel.alpha = 0
                },
                completion: { _ in
                    warningLabel.removeFromSuperview()
                    OverlayHelper.warningLabel = nil
                }
            )
        }
    }
}

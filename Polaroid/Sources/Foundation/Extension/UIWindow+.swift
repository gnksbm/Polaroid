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
        OverlayHelper.warningLabelBottomConstraint = label.bottomAnchor
            .constraint(equalTo: safeArea.topAnchor)
        OverlayHelper.warningLabelBottomConstraint?.isActive = true
        layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseOut],
            animations: { [weak self] in
                guard let self else { return }
                OverlayHelper.warningLabelBottomConstraint?.constant =
                label.bounds.height
                label.alpha = 1
                layoutIfNeeded()
            }
        )
    }
    
    func hideWarningLabel() {
        guard OverlayHelper.warningLabel != nil else { return }
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseOut],
            animations: { [weak self] in 
                OverlayHelper.warningLabelBottomConstraint?.constant = 0
                OverlayHelper.warningLabel?.alpha = 0
                self?.layoutIfNeeded()
            },
            completion: { _ in
                OverlayHelper.warningLabel?.removeFromSuperview()
            }
        )
    }
}

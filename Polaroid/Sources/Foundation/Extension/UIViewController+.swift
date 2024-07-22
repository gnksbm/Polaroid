//
//  UIViewController+.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

extension UIViewController {
    static func getCurrentRootVC() -> UIViewController {
        @UserDefaultsWrapper(key: .isJoinedUser, defaultValue: false)
        var isJoinedUser
        return isJoinedUser ?
        MainTabBarController() : UINavigationController(
            rootViewController: OnboardingViewController()
        )
    }
}

//
//  MainTabBarController.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

import Neat

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = TabKind.makeViewControllers()
    }
}

extension MainTabBarController {
    enum TabKind: Int, CaseIterable {
        case topic, random, search, liked
    }
}

extension MainTabBarController.TabKind {
    static func makeViewControllers() -> [UIViewController] {
        allCases.map { tabKind in
            UINavigationController(
                rootViewController: tabKind.viewController.nt.configure {
                    $0.tabBarItem(tabKind.tabBarItem)
                }
            )
        }
    }
    
    private var viewController: UIViewController {
        switch self {
        case .topic:
            TopicViewController()
        case .random:
            RandomViewController()
        case .search:
            SearchViewController()
        case .liked:
            UIViewController()
        }
    }
    
    private var tabBarItem: UITabBarItem {
        UITabBarItem(
            title: nil,
            image: image,
            selectedImage: selectedImage
        )
    }
    
    private var image: UIImage {
        switch self {
        case .topic:
            UIImage.tabTrendInactive
        case .random:
            UIImage.tabRandomInactive
        case .search:
            UIImage.tabSearchInactive
        case .liked:
            UIImage.tabLikeInactive
        }
    }
    
    private var selectedImage: UIImage? {
        switch self {
        case .topic:
            UIImage.tabTrend
        case .random:
            UIImage.tabRandom
        case .search:
            UIImage.tabSearch
        case .liked:
            UIImage.tabLike
        }
    }
}

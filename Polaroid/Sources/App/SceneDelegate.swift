//
//  SceneDelegate.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private let networkMonitor = NetworkMonitor.shared
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = .getCurrentRootVC()
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { 
        networkMonitor.start { [weak self] path in
            guard let self else { return }
            DispatchQueue.main.async {
                switch path.status {
                case .satisfied:
                    self.window?.hideWarningLabel()
                default:
                    self.window?.showWarningLabel(
                        message: "네크워크 연결을 확인해주세요"
                    )
                }
            }
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { 
        networkMonitor.stop()
    }
}

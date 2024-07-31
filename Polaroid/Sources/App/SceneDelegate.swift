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
        networkMonitor.startMonitoring { [weak self] isConnected in
            guard let self else { return }
            DispatchQueue.main.async {
                if isConnected {
                    self.window?.hideWarningLabel(with: "인터넷에 다시 연결됨")
                } else {
                    self.window?.showWarningLabel(
                        message: "인터넷 연결을 확인해주세요"
                    )
                }
            }
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { 
        networkMonitor.stopMonitoring()
    }
}

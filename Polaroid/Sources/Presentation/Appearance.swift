//
//  Appearance.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

enum Appearance {
    static func configureCommonUI() {
        configureNavigationBarUI()
        configureTabBarUI()
    }
    
    private static func configureNavigationBarUI() {
        let appearance = UINavigationBarAppearance().nt.configure { 
            $0.shadowColor(MPDesign.Color.gray)
                .configureWithOpaqueBackground()
        }
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        UINavigationBar.appearance().tintColor = MPDesign.Color.black
        UINavigationBar.appearance().titleTextAttributes = [
            .font: MPDesign.Font.heading.with(weight: .bold)
        ]
    }
    
    private static func configureTabBarUI() {
        let appearance = UITabBarAppearance().nt.configure { $0.shadowColor(MPDesign.Color.gray)
                .configureWithOpaqueBackground()
        }
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().tintColor = MPDesign.Color.black
    }
}

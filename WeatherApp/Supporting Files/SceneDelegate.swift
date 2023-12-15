//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by Denis Abramov on 05.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        self.window = UIWindow(windowScene: windowScene)
        
        let tabBarController = TabBarController()
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()

        
        
//        let vc = WeatherViewController()
//        
//        let navigationController = UINavigationController(rootViewController: vc)
//        
//        self.window = UIWindow(windowScene: windowScene)
//        self.window?.rootViewController = navigationController
//        self.window?.makeKeyAndVisible()
    }
}

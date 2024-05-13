//
//  SceneDelegate.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 5/5/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
 
        guard let windowScene = scene as? UIWindowScene else { return }
             
             let window = UIWindow(windowScene: windowScene)
            let navigationController = UINavigationController()

             coordinator = MainCoordinator(navigationController: navigationController)
             coordinator?.start()
             
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            self.window = window


    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}


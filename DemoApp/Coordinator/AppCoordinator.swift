//
//  AppCoordinator.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 9/5/24.
//

import Foundation
import UIKit

class AppCoordinator {
    
     let window: UIWindow
     let navigationController: UINavigationController
     var firstViewController: HeroViewController?
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        let firstViewController = HeroViewController()
        firstViewController.coordinator = self
        navigationController.pushViewController(firstViewController, animated: false)
        self.firstViewController = firstViewController
    }
}

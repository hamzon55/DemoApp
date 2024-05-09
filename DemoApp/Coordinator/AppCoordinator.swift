//
//  AppCoordinator.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 9/5/24.
//

import Foundation
import UIKit

class AppCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private var firstViewController: FirstViewController?
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        let firstViewController = FirstViewController()
        firstViewController.coordinator = self
        navigationController.pushViewController(firstViewController, animated: false)
        self.firstViewController = firstViewController
    }
}

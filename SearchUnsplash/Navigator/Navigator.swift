//
//  Navigator.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 13/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

class Navigator {
    
    var rootNavigationController: UINavigationController {
        return navigationController
    }
    
    private let navigationController: UINavigationController
    private var homeVC: HomeViewController?

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let rootViewController: UIViewController = getHomeViewController()
        navigationController.setViewControllers([
            rootViewController
        ], animated: false)
    }
    
    private func getHomeViewController() -> UIViewController {
        return HomeViewController(nibName: nil, bundle: nil)
    }
}

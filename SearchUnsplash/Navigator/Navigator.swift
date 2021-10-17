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
    private var homeVM: HomeViewModel?

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
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel: viewModel)
        homeVM = viewModel
        homeVC = viewController
        
        viewController.onActions = { [weak self] actions in
            guard let `self` = self else {
                return
            }
            
            switch actions {
            case .detail(let query):
                self.navigationController.pushViewController(
                    self.getPhotoResult(query: query),
                    animated: true
                )
            }
            
        }
        return viewController
    }
    
    private func getPhotoResult(query: String) -> UIViewController {
        let viewModel = PhotoResultViewModel(query: query)
        let viewController = PhotoResutlViewController(viewModel: viewModel)
        viewController.onActions = { [weak self] actions in
            guard let `self` = self else {
                return
            }

            switch actions {
            case .back:
                self.navigationController.popViewController(animated: true)
            }

        }
        return viewController
    }
}

//
//  PhotoResutlViewController.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 17/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit
import Combine

class PhotoResutlViewController: ShowableViewController {
    
    enum Actions {
        case back
    }
    
    var onActions: ((Actions) -> Void)?
    
    @IBOutlet private weak var photoListView: PhotoListView!
    
    private let viewModel: PhotoResultViewModel
    
    init(viewModel: PhotoResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configurePhotoListView()
        viewModel.load()
    }
    
    private func configureNavBar() {
        title = viewModel.query
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "ArrowLeft.png"), for: .normal)
        button.addTarget(self, action:#selector(leftButtonOnTapped), for: .touchDragInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItems = [barButton]
        
        let rightButton = UIButton(type: UIButton.ButtonType.custom)
        rightButton.setImage(UIImage(named: "Filter.png"), for: .normal)
        rightButton.addTarget(self, action:#selector(rightButtonOnTapped), for: .touchDragInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func configurePhotoListView() {
        photoListView.bindViewModel(viewModel: viewModel.photoListViewModel)
        photoListView.delegate = self
    }
    
    @objc private func leftButtonOnTapped() {
        onActions?(.back)
    }
    
    @objc private func rightButtonOnTapped() {
        let filterViewController = FilterViewController(viewModel: viewModel.filterViewModel)
        let navController = UINavigationController(rootViewController: filterViewController)
        filterViewController.onDismiss = { [weak navController, weak self] (parameter) in
            navController?.dismiss(animated: true, completion: nil)
            self?.viewModel.load(parameter: parameter)
        }
        navigationController?.present(navController, animated: true, completion: nil)
    }
}


extension PhotoResutlViewController: PhotoListViewDelegate {
    func onSelectPhoto(url: String) {
        show(url: url)
    }
    
    func showError(message: String) {
        showToast(message: message)
    }
}


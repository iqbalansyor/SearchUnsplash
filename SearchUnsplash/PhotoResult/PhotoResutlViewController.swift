//
//  PhotoResutlViewController.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 17/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit
import Combine

class PhotoResutlViewController: UIViewController {
    
    enum Actions {
        case back
    }
    
    var onActions: ((Actions) -> Void)?
    
    @IBOutlet private weak var photoListView: PhotoListView!
    
    private let viewModel: PhotoResultViewModel
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?
    
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
        animator?.stopAnimation(true)
        cancellable?.cancel()
        
        let newImageView = UIImageView()
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        cancellable = loadImage(for: url)
            .sink { [weak self] image in
                self?.showImage(imageView: newImageView, image: image)
        }
    }
    
    @objc func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    private func showImage(imageView: UIImageView, image: UIImage?) {
        imageView.alpha = 0.0
        animator?.stopAnimation(true)
        imageView.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            imageView.alpha = 1.0
        })
    }
    
    private func loadImage(for url: String) -> AnyPublisher<UIImage?, Never> {
        return Just(url)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                let url = URL(string: url)!
                return ImageLoader.shared.loadImage(from: url)
            })
            .eraseToAnyPublisher()
    }
    
    func showError(message: String) {
        showToast(message: message)
    }
}


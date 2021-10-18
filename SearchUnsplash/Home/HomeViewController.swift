//
//  HomeViewController.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 13/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit
import Alamofire
import Combine

class HomeViewController: UIViewController {
    
    enum Actions {
        case detail(query: String)
    }
    
    var onActions: ((Actions) -> Void)?
    
    @IBOutlet private weak var searchContainerView: UIView!
    @IBOutlet private weak var photoListView: PhotoListView!
    @IBOutlet private weak var searchTextField: UITextField!
    
    private let viewModel: HomeViewModel
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCornerRadius()
        configurePhotoListView()
        viewModel.load()
        searchTextField.delegate = self
    }
    
    private func configurePhotoListView() {
        photoListView.bindViewModel(viewModel: viewModel.photoListViewModel)
        photoListView.delegate = self
    }
    
    private func configureCornerRadius() {
        searchContainerView.layer.cornerRadius = 8
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        textField.resignFirstResponder()
        onActions?(.detail(query: text))
        return true
    }
}

extension HomeViewController: PhotoListViewDelegate {
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

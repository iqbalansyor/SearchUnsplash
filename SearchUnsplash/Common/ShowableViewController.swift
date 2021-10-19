//
//  UIViewController+ShowImage.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 19/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit
import Combine

class ShowableViewController: UIViewController {
    
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?
    
    func show(url: String) {
        animator?.stopAnimation(true)
        cancellable?.cancel()
        
        let newImageView = UIImageView()
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissFullscreenImage)
        )
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
}

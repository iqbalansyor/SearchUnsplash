//
//  PhotoCell.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 14/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit
import SDWebImage
import Combine

class PhotoCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.alpha = 0.0
        animator?.stopAnimation(true)
        cancellable?.cancel()
    }
    
    func bindViewModel(viewModel: PhotoCellViewModel) {
        //        imageView.sd_setImage(
        //            with: URL(string: viewModel.photoUrl),
        //            placeholderImage: nil)
        cancellable = loadImage(for: viewModel.photoUrl)
            .sink { [weak self] image in
                self?.showImage(image: image)
        }
    }
    
    private func showImage(image: UIImage?) {
        imageView.alpha = 0.0
        animator?.stopAnimation(true)
        imageView.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.imageView.alpha = 1.0
        })
    }
    
    private func loadImage(for url: String) -> AnyPublisher<UIImage?, Never> {
        showLoading(state: true)
        return Just(url)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                let url = URL(string: url)!
                return ImageLoader.shared.loadImage(from: url)
            })
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.showLoading(state: false)
            })
            .eraseToAnyPublisher()
    }
    
    private func showLoading(state: Bool) {
        if (state) {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        loadingIndicator.isHidden = !state
        imageView.isHidden = state
    }
}

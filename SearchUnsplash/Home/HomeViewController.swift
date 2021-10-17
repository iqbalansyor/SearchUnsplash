//
//  HomeViewController.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 13/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var searchContainerView: UIView!
    @IBOutlet private weak var photoCollectionView: UICollectionView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadMoreIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var photoBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var photoListView: PhotoListView!
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureCornerRadius()
        configurePhotoListView()
        viewModel.load()
    }
    
    private func configurePhotoListView() {
        photoListView.bindViewModel(viewModel: viewModel.photoListViewModel)
    }
    
    private func configureCollectionView() {
        if let layout = photoCollectionView.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        
        photoCollectionView.register(
            UINib(nibName: String(describing: PhotoCell.self), bundle: nil),
            forCellWithReuseIdentifier: String(describing: PhotoCell.self))
    }
    
    private func configureCornerRadius() {
        searchContainerView.layer.cornerRadius = 8
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {
            if (viewModel.isLoadMore) { return }
            viewModel.loadMore()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("&&& count \(viewModel.cellViewModels.count)")
        return viewModel.cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let shouldShowEmpty = viewModel.cellViewModels.count == 0
        print("&&& count cellfor \(viewModel.cellViewModels.count)")
        if (shouldShowEmpty) {
            // TODO: Dequeque empty state cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: PhotoCell.self),
            for: indexPath) as? PhotoCell else {
                return PhotoCell()
        }
        
        print("&&& render cell")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = viewModel.cellViewModels.count
        guard count > 0,
            let cell = cell as? PhotoCell else {
                return
        }
        
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        print("&&& display cell \(cellViewModel.photoUrl)")
        cell.bindViewModel(viewModel: cellViewModel)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (UIScreen.main.bounds.width - 18) / 2
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let height = (cellViewModel.height / cellViewModel.width) * width
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: CustomLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let width: CGFloat = (UIScreen.main.bounds.width - 18) / 2
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let height = (cellViewModel.height / cellViewModel.width) * width
        return height
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func showLoading(state: Bool) {
        if (state) {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        loadingIndicator.isHidden = !state
        photoCollectionView.isHidden = state
    }
    
    func reloadData() {
        photoCollectionView.reloadData()
    }
    
    func showLoadingMore(state: Bool) {
        loadMoreIndicator.isHidden = !state
        if (state) {
            photoBottomConstraint.constant = 47.0
        } else {
            photoBottomConstraint.constant = 0.0
        }
    }
}

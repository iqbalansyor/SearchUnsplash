//
//  PhotoListView.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 16/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

protocol PhotoListViewDelegate: class {
    func onSelectPhoto(url: String)
    func showError(message: String)
}

class PhotoListView: UIView {
    
    weak var delegate: PhotoListViewDelegate?
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var photoCollectionView: UICollectionView!
    @IBOutlet private weak var loadMoreIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var photoBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var errorView: UIView!
    
    private var viewModel: PhotoListViewModel?
    private var refresher: UIRefreshControl?
    private let PHOTO_BOTTOM_CONSTRAINT: CGFloat = 47
    private let INSET_WIDTH: CGFloat = 18
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func bindViewModel(viewModel: PhotoListViewModel) {
        self.viewModel = viewModel
        viewModel.delegate = self
        photoCollectionView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        let isOnBottom = offsetY > contentHeight - scrollView.frame.size.height
        if isOnBottom {
            if (viewModel?.isLoadMore == true) { return }
            viewModel?.loadMore()
        }
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: PhotoListView.self),
                                 owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
        
        configureCollectionView()
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
        photoCollectionView.register(
            UINib(nibName: String(describing: EmptyPhotoCell.self), bundle: nil),
            forCellWithReuseIdentifier: String(describing: EmptyPhotoCell.self))
        
        refresher = UIRefreshControl()
        guard let refresher = refresher else { return }
        photoCollectionView.alwaysBounceVertical = true
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        photoCollectionView.addSubview(refresher)
    }
    
    @objc private func loadData() {
        viewModel?.refresh()
    }
}

extension PhotoListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel,
            viewModel.cellViewModels.count > 0 else {
                return
        }
        
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let url = cellViewModel.fullPhotoUrl
        delegate?.onSelectPhoto(url: url)
    }
}

extension PhotoListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return  0 }
        let shouldShowEmpty = viewModel.cellViewModels.count == 0
        if (shouldShowEmpty) {
           return 1
        }
        return viewModel.cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let viewModel = viewModel else {
            return  UICollectionViewCell()
        }
        
        let shouldShowEmpty = viewModel.cellViewModels.count == 0
        if (shouldShowEmpty) {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: EmptyPhotoCell.self),
                for: indexPath) as? EmptyPhotoCell else {
                    return EmptyPhotoCell()
            }
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: PhotoCell.self),
            for: indexPath) as? PhotoCell else {
                return PhotoCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
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

extension PhotoListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let viewModel = viewModel else { return CGSize( )}
        let width: CGFloat = (UIScreen.main.bounds.width - 18) / 2
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let height = (cellViewModel.height / cellViewModel.width) * width
        return CGSize(width: width, height: height)
    }
}

extension PhotoListView: CustomLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        guard let viewModel = viewModel  else { return 0 }
        
        let shouldShowEmpty = viewModel.cellViewModels.count == 0
        if (shouldShowEmpty) {
            return 100
        }
        
        let width: CGFloat = (UIScreen.main.bounds.width - INSET_WIDTH) / 2
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let height = (cellViewModel.height / cellViewModel.width) * width
        return height
    }
}

extension PhotoListView: PhotoListViewModelDelegate {
    func showLoading(state: Bool) {
        if (state) {
            errorView.isHidden = true
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
            photoBottomConstraint.constant = PHOTO_BOTTOM_CONSTRAINT
        } else {
            photoBottomConstraint.constant = 0.0
        }
    }
    
    func onRefresh(state: Bool) {
        if (state) {
            refresher?.beginRefreshing()
        } else {
            refresher?.endRefreshing()
        }
    }
    
    func showError(message: String) {
        errorView.isHidden = false
        delegate?.showError(message: message)
    }
}

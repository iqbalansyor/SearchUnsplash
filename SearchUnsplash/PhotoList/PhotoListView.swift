//
//  PhotoListView.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 16/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

class PhotoListView: UIView {

    @IBOutlet private var contentView: UIView!

    @IBOutlet private weak var photoCollectionView: UICollectionView!
    @IBOutlet private weak var loadMoreIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var photoBottomConstraint: NSLayoutConstraint!
    private var viewModel: PhotoListViewModel?
 
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
        
        photoCollectionView.reloadData()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ExpenseListView", owner: self, options: nil)
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
    }
}

extension PhotoListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension PhotoListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return  0 }
        print("&&& count \(viewModel.cellViewModels.count)")
        return viewModel.cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let viewModel = viewModel else {
            return  UICollectionViewCell()
        }
        
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
        let width: CGFloat = (UIScreen.main.bounds.width - 18) / 2
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let height = (cellViewModel.height / cellViewModel.width) * width
        return height
    }
}

extension PhotoListView: PhotoListViewModelDelegate {
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

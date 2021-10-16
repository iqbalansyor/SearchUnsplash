//
//  PhotoListViewModel.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 16/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

protocol PhotoListViewModelDelegate: class {
    func showLoading(state: Bool)
    func showLoadingMore(state: Bool)
    func reloadData()
}

class PhotoListViewModel {
    var cellViewModels: [PhotoCellViewModel] = []
    weak var delegate: PhotoListViewModelDelegate?
    private var page: Int = 1
    var isLoadMore: Bool = false
    
    func load() {
        page = 1
        isLoadMore = false
        
        getPhotos()
    }
    
    func loadMore() {
        if (isLoadMore) { return }
        page += 1
        isLoadMore = true
        
        getPhotos()
    }
    
    private func getPhotos() {
        if (isLoadMore) {
            delegate?.showLoadingMore(state: true)
        } else {
            delegate?.showLoading(state: true)
        }
        var parameters: [String: Any] = [:]
        parameters["query"] = "office"
        parameters["page"] = page
        parameters["per_page"] = 10
        let onSuccess = { [weak self] (result: PhotoResult?) in
            
            guard let `self` = self else { return }
            
            if (self.isLoadMore) {
                self.delegate?.showLoadingMore(state: false)
            } else {
                self.delegate?.showLoading(state: false)
            }
            
            var cellViewModels: [PhotoCellViewModel] = []
            result?.results.forEach({ (item) in
                let cellViewModel = PhotoCellViewModel(height: CGFloat(item.height),
                                                       width: CGFloat(item.width),
                                                       url: item.urls.small
                )
                cellViewModels.append(cellViewModel)
            })
            
            if (self.isLoadMore) {
                let newCellViewModels = self.cellViewModels + cellViewModels
                self.cellViewModels = newCellViewModels
                self.isLoadMore = false
            } else {
                self.cellViewModels = cellViewModels
            }
            self.delegate?.reloadData()
        }
        let onError = { (error: Error) in
            print(error)
        }
        
        ApiService.get(
            parameter: parameters,
            onSuccess: onSuccess,
            onError: onError
        )
    }

}

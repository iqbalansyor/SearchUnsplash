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
    func onRefresh(state: Bool)
}

class PhotoListViewModel {
    // Public properties
    var cellViewModels: [PhotoCellViewModel] = []
    weak var delegate: PhotoListViewModelDelegate?
    var isLoadMore: Bool = false
    
    // Private properties
    private var page: Int = 1
    private let photoService: PhotoServiceBase
    private var isOnRefresh: Bool = false
    private var parameter: [String: Any] = [:]
    
    init(service: PhotoServiceBase = PhotoService()) {
        self.photoService = service
    }
    
    // Public methods
    
    func load(with parameter: [String: Any]) {
        page = 1
        isLoadMore = false
        self.parameter = parameter
        getPhotos(with: parameter)
    }
    
    func loadMore() {
        if (isLoadMore) { return }
        page += 1
        isLoadMore = true
        
        getPhotos(with: parameter)
    }
    
    func refresh() {
        isOnRefresh = true
        load(with: parameter)
    }
    
    // Private methods
    private func getPhotos(with parameters: [String: Any]) {
        var newParameter = parameters
        newParameter["page"] = page
        newParameter["per_page"] = 10
        
        if (isLoadMore) {
            delegate?.showLoadingMore(state: true)
        } else if (isOnRefresh) {
            delegate?.onRefresh(state: true)
        } else {
            delegate?.showLoading(state: true)
        }
        let onSuccess = { [weak self] (result: PhotoResult?) in
            
            guard let `self` = self else { return }
            
            if (self.isLoadMore) {
                self.delegate?.showLoadingMore(state: false)
            } else if (self.isOnRefresh) {
                self.delegate?.onRefresh(state: false)
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
                
                if (self.isOnRefresh) {
                    self.isOnRefresh = false
                }
            }
            self.delegate?.reloadData()
        }
        let onError = { (error: Error) in
            print(error)
        }
        
        photoService.getPhotos(
            parameter: newParameter,
            onSuccess: onSuccess,
            onError: onError
        )
    }
    
}

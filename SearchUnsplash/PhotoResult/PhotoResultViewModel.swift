//
//  PhotoResultViewModel.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 17/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

class PhotoResultViewModel {
    
    let query: String
    
    let photoListViewModel: PhotoListViewModel = PhotoListViewModel()
    
    init(query: String) {
        self.query = query
    }
    
    func load() {
        var parameter = [String: Any]()
        parameter["query"] = query
        photoListViewModel.load(with: parameter)
    }
}

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
    let filterViewModel: FilterViewModel = FilterViewModel()
    
    init(query: String) {
        self.query = query
    }
    
    func load(parameter: [String: Any] = [:]) {
        var newParameter = [String: Any]()
        newParameter["query"] = query
        
        parameter.forEach { (key, value) in
            newParameter[key] = value
        }
        photoListViewModel.load(with: newParameter)
    }
}

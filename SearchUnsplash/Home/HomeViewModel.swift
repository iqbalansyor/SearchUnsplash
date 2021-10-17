//
//  HomeViewModel.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 14/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

class HomeViewModel {
    
    let photoListViewModel = PhotoListViewModel()
    private let RANDOM_QUERY = "random"
    
    func load() {
        var parameter = [String: Any]()
        parameter["query"] = RANDOM_QUERY
        photoListViewModel.load(with: parameter)
    }
}

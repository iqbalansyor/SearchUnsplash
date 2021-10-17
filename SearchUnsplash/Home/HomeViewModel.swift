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
    
    func load() {
        photoListViewModel.load()
    }
}

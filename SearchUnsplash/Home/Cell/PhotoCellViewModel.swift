//
//  PhotoCellViewModel.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 14/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

class PhotoCellViewModel {
    var photoUrl = "https://picsum.photos/200/300"
    var width: CGFloat =  200
    var height: CGFloat = 300
    
    init(height: CGFloat, width: CGFloat, url: String) {
        self.height = height
        self.width = width
        self.photoUrl = url
    }
}

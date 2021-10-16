//
//  PhotoItem.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 14/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

struct PhotoResult: Decodable {
    let total: Int
    let total_pages: Int
    let results: [PhotoItem]
}

struct PhotoItem: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: PhotoUrls
}

struct PhotoUrls: Decodable {
    let raw: String
    let full: String
    let small: String
}

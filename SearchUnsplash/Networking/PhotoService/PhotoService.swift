//
//  PhotoServiceProtocol.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 17/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

protocol PhotoServiceBase {
    func getPhotos(
        parameter: [String: Any],
        onSuccess: ((PhotoResult?) -> Void)?,
        onError: ((Error) -> Void)?)
}

class PhotoService : PhotoServiceBase {
    func getPhotos(
        parameter: [String : Any],
        onSuccess: ((PhotoResult?) -> Void)?,
        onError: ((Error) -> Void)?) {
        ApiService.GET(
            parameter: parameter,
            onSuccess: onSuccess,
            onError: onError
        )
    }
    
}

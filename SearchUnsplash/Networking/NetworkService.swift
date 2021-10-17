//
//  NetworkService.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 15/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import Foundation
import Alamofire

struct Error {
    let errorMessage: String?
}

class ApiService {
    static func GET<T: Decodable>(
        parameter: [String: Any],
        onSuccess: ((T?) -> Void)?,
        onError: ((Error) -> Void)?) {
        
        let clientId = KeyManager.getClientKey()
        var urlRequest = "https://api.unsplash.com/search/photos?client_id=\(clientId)"
        
        parameter.forEach { (key, value) in
            urlRequest += "&\(key)=\(value)"
        }
        
        AF.request(urlRequest)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success:
                    onSuccess?(response.value)
                    
                case .failure(let error):
                    onError?(Error(errorMessage: error.errorDescription))
                    
                }
        }
    }
}

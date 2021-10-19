//
//  NetworkService.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 15/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import Foundation

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
        
        guard let gitUrl = URL(string: urlRequest) else { return }
        
        let request = NSMutableURLRequest(url: gitUrl)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    onError?(Error(errorMessage: error.localizedDescription))
                }
            }
            
            if let data = data {
                do {
                    let paarsedData = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        onSuccess?(paarsedData)
                    }
                } catch {
                    DispatchQueue.main.async {
                        onError?(Error(errorMessage: "Oops saomething wrong, please try later"))
                    }
                }
            }
        }
        
        task.resume()
    }
}

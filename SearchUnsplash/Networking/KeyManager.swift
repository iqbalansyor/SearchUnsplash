//
//  KeyManager.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 16/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import Foundation

class KeyManager {
    
    // Simple crypt mechanisme to obfuscated `clientKey`, with `co` and `learn` as cypher.
    static func getClientKey() -> String {
        var clientKey: String = "coYXmeNGVkR_y1X5z6l80JpJkdqe4Wl4T5sdJO06sQkdklearn"
        let count = clientKey.count
        clientKey = clientKey.substring(from: 2, to: count - 5)
        return clientKey
    }
}

extension String {
    func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: to - from)
        return String(self[start ..< end])
    }

    func substring(range: NSRange) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }
}

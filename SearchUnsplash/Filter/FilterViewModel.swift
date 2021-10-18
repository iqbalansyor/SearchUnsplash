//
//  FilterViewModel.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 17/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import Foundation

class FilterViewModel {
    
    let filterItems: [[FilterItem]] = [
        [.relevance, .newest],
        [.anyColour, .blacknwhite],
        [.anyOrientation, .landscape, .squarish]
    ]
    
    let filterHeader: [FilterHeader] = [.sortBy, .colour, .orientation]
    
    var sortByActive: FilterItem? = .relevance
    var colourActive: FilterItem = .anyColour
    var orientationActive: FilterItem = .anyOrientation
    
    func getParameter() -> [String: Any] {
        var parameter = [String: Any]()
        if let sortByActive = sortByActive {
            parameter["order_by"] = sortByActive.getValue()
        }
        
        if colourActive == .blacknwhite {
            parameter["color"] = colourActive.getValue()
        }
        
        if orientationActive != .anyOrientation {
            parameter["orientation"] = orientationActive.getValue()
        }
        
        return parameter
    }
}

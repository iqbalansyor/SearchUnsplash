//
//  FilterItem.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 18/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import Foundation

enum FilterItem {
    case relevance
    case newest
    case blacknwhite
    case anyColour
    case anyOrientation
    case portrait
    case landscape
    case squarish
    
    func getDisplayText() -> String {
        switch self {
        case .relevance: return "Relevant"
        case .newest: return "Newest"
        case .blacknwhite: return "Black And White"
        case .anyColour: return "Any Colour"
        case .anyOrientation: return "Any"
        case .portrait: return "Potrait"
        case .landscape: return "Landscape"
        case .squarish: return "Square"
        }
    }
    
    func getValue() -> String {
        switch self {
        case .relevance: return "relevant"
        case .newest: return "latest"
        case .blacknwhite: return "black_and_white"
        case .anyColour: return "any_colour"
        case .anyOrientation: return "any_orientation"
        case .portrait : return "potrait"
        case .landscape: return "landscape"
        case .squarish: return "squarish"
        }
    }
}

enum FilterHeader {
    case sortBy
    case colour
    case orientation
    
    func getDisplayText() -> String {
        switch self {
        case .sortBy: return "Sort By"
        case .colour: return "Color"
        case .orientation: return "Orientation"
        }
    }
}

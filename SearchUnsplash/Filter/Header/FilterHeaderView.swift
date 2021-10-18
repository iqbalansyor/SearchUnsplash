//
//  FilterHeaderView.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 17/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

class FilterHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var headerLabel: UILabel!
    
    func bind(header: FilterHeader) {
        headerLabel.text = header.getDisplayText()
    }
}

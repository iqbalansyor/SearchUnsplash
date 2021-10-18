//
//  FilterCellTableViewCell.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 17/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet private weak var checkView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    
    func bind(item: FilterItem, isActive: Bool) {
        label.text = item.getDisplayText()
        checkView.isHidden = !isActive
    }
}

//
//  HomeViewController.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 13/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak private  var searchContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCornerRadius()
    }
    
    private func configureCornerRadius() {
        searchContainerView.layer.cornerRadius = 8
    }
}

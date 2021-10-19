//
//  HomeViewController.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 13/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit
import Alamofire
import Combine

class HomeViewController: ShowableViewController {
    
    enum Actions {
        case detail(query: String)
    }
    
    var onActions: ((Actions) -> Void)?
    
    @IBOutlet private weak var searchContainerView: UIView!
    @IBOutlet private weak var photoListView: PhotoListView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchImageView: UIImageView!
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCornerRadius()
        configurePhotoListView()
        configureSearchView()
        viewModel.load()
    }
    
    private func configurePhotoListView() {
        photoListView.bindViewModel(viewModel: viewModel.photoListViewModel)
        photoListView.delegate = self
    }
    
    private func configureCornerRadius() {
        searchContainerView.layer.cornerRadius = 8
    }
    
    private func configureSearchView() {
        searchTextField.delegate = self
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(doSearch)
        )
        searchImageView.addGestureRecognizer(tap)
    }
    
    @objc func doSearch(sender: UITapGestureRecognizer) {
        guard let text = searchTextField.text else { return }
        searchTextField.resignFirstResponder()
        onActions?(.detail(query: text))
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        textField.resignFirstResponder()
        onActions?(.detail(query: text))
        return true
    }
}

extension HomeViewController: PhotoListViewDelegate {
    func onSelectPhoto(url: String) {
        show(url: url)
    }
    
    func showError(message: String) {
        showToast(message: message)
    }
}

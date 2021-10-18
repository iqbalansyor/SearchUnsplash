//
//  FilterViewController.swift
//  SearchUnsplash
//
//  Created by iqbalansyor on 17/10/21.
//  Copyright © 2021 iqbalansyor. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    var onDismiss: (([String: Any]) -> ())?
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: FilterViewModel
    private let HEADER_HEIGHT: CGFloat = 50
    private let CELL_HEIGHT: CGFloat = 40
    
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureTableView()
    }
    
    private func configureNavBar() {
        navigationItem.title = "Feedback"
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "ArrowLeft.png"), for: .normal)
        button.addTarget(self, action:#selector(leftButtonOnTapped), for: .touchDragInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItems = [barButton]
    }
    
    private func configureTableView() {
        tableView.register(
            UINib(nibName: String(describing: FilterCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: FilterCell.self))
        tableView.register(
            UINib(nibName: String(describing: FilterHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: FilterHeaderView.self))
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()
        tableView.insetsContentViewsToSafeArea = true
    }
    
    @objc private func leftButtonOnTapped() {
        let parameter = viewModel.getParameter()
        onDismiss?(parameter)
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        let parameter = viewModel.getParameter()
        onDismiss?(parameter)
    }
}

extension FilterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.filterHeader.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FilterCell.self),
            for: indexPath) as? FilterCell else {
                return FilterCell()
        }
        let filterItem = viewModel.filterItems[indexPath.section][indexPath.row]
        var isActive = false
        switch viewModel.filterHeader[indexPath.section] {
        case .sortBy:
            isActive = filterItem == viewModel.sortByActive
        case .colour:
            isActive = filterItem == viewModel.colourActive
        case .orientation:
            isActive = filterItem == viewModel.orientationActive
        }
        cell.bind(item: filterItem, isActive: isActive)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: FilterHeaderView.self)) as? FilterHeaderView
        header?.bind(header: viewModel.filterHeader[section])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filterItem = viewModel.filterItems[indexPath.section][indexPath.row]
        switch viewModel.filterHeader[indexPath.section] {
        case .sortBy:
            if (viewModel.sortByActive == filterItem) {
                viewModel.sortByActive = nil
            } else {
                viewModel.sortByActive = filterItem
            }
        case .colour:
            viewModel.colourActive = filterItem
        case .orientation:
            viewModel.orientationActive = filterItem
        }
        
        tableView.reloadData()
    }
}



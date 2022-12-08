//
//  CityListViewController.swift
//  WeatherDevTask
//
//  Created by Mikhail on 07.12.2022.
//

import UIKit

final class CityListViewController: UITableViewController {
    
    let citySearchField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Search"
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    private func setupTableView() {
        tableView.register(SearchTableViewCell.self,
                           forCellReuseIdentifier: SearchTableViewCell.reuseID)
        tableView.register(CityTableViewCell.self,
                           forCellReuseIdentifier: CityTableViewCell.reuseID)
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 10
        }
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseID,
                                                     for: indexPath)
        default:
            return tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseID,
                                                     for: indexPath)
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseID,
//                                                 for: indexPath)

    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        100
//    }
}

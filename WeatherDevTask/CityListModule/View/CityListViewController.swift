//
//  CityListViewController.swift
//  WeatherDevTask
//
//  Created by Mikhail on 07.12.2022.
//

import UIKit

final class CityListViewController: UITableViewController {
    
    // MARK: - UI elements
    
    private let citySearchField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Search"
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    // MARK: - Internal properties
    
    var presenter: CityListPresenterProtocol?
    

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        presenter?.getWeather()
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
//        tableView.allowsSelection = false
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
            return presenter?.weatherDataArray.count ?? 0

        }
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseID,
                                                     for: indexPath)
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseID,
                                                     for: indexPath) as! CityTableViewCell
            guard let viewData = presenter?.weatherDataArray[indexPath.row] else { return UITableViewCell() }

            cell.configureWith(viewData)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailWeatherViewController = ModuleBulder.createDetailWeatherModule()
        navigationController?.pushViewController(detailWeatherViewController, animated: true)
    }
}

// MARK: - CityListViewProtocol

extension CityListViewController: CityListViewProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func loadWeather(viewData: CityCurrentWeatherViewData) {
//        print("loading weather")
    }
}

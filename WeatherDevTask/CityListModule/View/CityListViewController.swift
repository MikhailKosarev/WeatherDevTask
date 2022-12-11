//
//  CityListViewController.swift
//  WeatherDevTask
//
//  Created by Mikhail on 07.12.2022.
//

import UIKit

final class CityListViewController: UITableViewController {
    
    // MARK: - UI elements
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - Internal properties
    
    var presenter: CityListPresenterProtocol?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setConstraints()
        presenter?.getWeather()
        showSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateNavBarColor()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        title = "Weather"
        view.backgroundColor = .black
        view.addSubview(activityIndicator)
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
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            // activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func updateNavBarColor() {
        navigationController?.navigationBar.prefersLargeTitles = true
        // setup style
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // remove the back button text:
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
//        self.navigationController?.navigationBar.setNeedsLayout()
    }
    
    private func showSpinner() {
        activityIndicator.startAnimating()
    }
    
    private func hideSpinner() {
        activityIndicator.stopAnimating()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        // search section
        case 0:
            return 1
        // city list section
        case 1:
            return presenter?.getNumberOfCities() ?? 0
        // default case
        default:
            return 0
        }
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // search section
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseID,
                                                           for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        // city list section
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseID,
                                                     for: indexPath) as! CityTableViewCell
            guard let viewData = presenter?.filteredWeatherDataArray[indexPath.row] else {
                return UITableViewCell()
            }
            cell.configureWith(viewData)
            return cell
        // default case
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CityTableViewCell,
              let cityName = cell.cityNameLabel.text else { return }
        
        let detailWeatherViewController = ModuleBulder.createDetailWeatherModule(currentCity: cityName)
        navigationController?.pushViewController(detailWeatherViewController, animated: true)
    }
}

// MARK: - CitySearchDelegateProtocol

extension CityListViewController: CitySearchDelegateProtocol {
    func searchTextChanged(searchText: String) {
        presenter?.filterCitiesStarting(with: searchText)
    }
}

// MARK: - CityListViewProtocol

extension CityListViewController: CityListViewProtocol {
    func reloadCityListSection() {
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        hideSpinner()
    }
}

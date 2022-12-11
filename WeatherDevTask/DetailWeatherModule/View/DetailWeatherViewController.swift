//
//  DetailWeatherViewController.swift
//  WeatherDevTask
//
//  Created by Mikhail on 08.12.2022.
//

import UIKit

final class DetailWeatherViewController: UIViewController {
    
    // MARK: - UI elements
    
    private let weatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.separatorColor = .white.withAlphaComponent(0.3)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - Private properties
    
    private let currentForecastView = CurrentForecastView()
    
    // MARK: - Internal properties
    
    var presenter: DetailWeatherPresenterProtocol?
    var currentCity: String?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupWeatherTableView()
        setConstraints()
        showSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateNavBarColor()
        presenter?.getWeatherFor(city: currentCity)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        view.backgroundColor = Constants.detailWeatherScreenBackgroundColor
        view.addSubview(currentForecastView)
        view.addSubview(weatherTableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupWeatherTableView() {
        // register cells
        weatherTableView.register(HourlyForecastTableViewCell.self,
                                  forCellReuseIdentifier: HourlyForecastTableViewCell.reuseID)
        weatherTableView.register(DailyForecastTableViewCell.self,
                                  forCellReuseIdentifier: DailyForecastTableViewCell.reuseID)
        weatherTableView.register(TodaysDescriptionTableViewCell.self,
                                  forCellReuseIdentifier: TodaysDescriptionTableViewCell.reuseID)
        weatherTableView.register(OtherParametersTableViewCell.self,
                                  forCellReuseIdentifier: OtherParametersTableViewCell.reuseID)
        
        // set delegates
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
    }
    
    private func updateNavBarColor() {
        navigationController?.navigationBar.prefersLargeTitles = false
        // setup style
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.isTranslucent = true
        navBar?.tintColor = .white
    }
    
    private func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // currentForecastView
            currentForecastView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            currentForecastView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            // weatherTableView
            weatherTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            weatherTableView.topAnchor.constraint(equalTo: currentForecastView.bottomAnchor,
                                                  constant: 50),
            weatherTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            // activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func showSpinner() {
        activityIndicator.startAnimating()
    }
    
    private func hideSpinner() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - UITableViewDataSource

extension DetailWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = DetailWeatherTableViewSection(sectionIndex: section) else {
            return 0
        }
        switch section {
        case .hourlyForecast:
            return presenter?.getNumberOfHourlyForecastRows() ?? 0
        case .dailyForecast:
            return presenter?.getNumberOfDailyForecastRows() ?? 0
        case .todaysDescription:
            return presenter?.getNumberOfTodaysDescriptionRows() ?? 0
        case .otherParameters:
            return presenter?.getNumberOfOtherParametersRows() ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = DetailWeatherTableViewSection(sectionIndex: indexPath.section) else {
            return UITableViewCell()
        }
        switch section {
        case .hourlyForecast:
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: HourlyForecastTableViewCell.reuseID,
                                                                  for: indexPath) as? HourlyForecastTableViewCell else {
                return UITableViewCell()
            }
            guard let hourlyForecastViewData = presenter?.getHourlyForecastData() else { return UITableViewCell() }
            cell.configureWith(viewData: hourlyForecastViewData)
            return cell
        case .dailyForecast:
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.reuseID,
                                                            for: indexPath) as? DailyForecastTableViewCell else { return UITableViewCell() }
            guard let dailyForecastViewData = presenter?.getDailyForecastDataFor(indexPath.row) else { return UITableViewCell() }
            cell.configureWith(viewData: dailyForecastViewData)
            return cell
        case .todaysDescription:
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: TodaysDescriptionTableViewCell.reuseID,
                                                                  for: indexPath) as? TodaysDescriptionTableViewCell else { return UITableViewCell() }
            guard let todaysDescriptionViewData = presenter?.getTodaysDescriptionData() else { return UITableViewCell() }
            cell.configureWith(viewData: todaysDescriptionViewData)
            return cell
        case .otherParameters:
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: OtherParametersTableViewCell.reuseID,
                                                                  for: indexPath)  as? OtherParametersTableViewCell else { return UITableViewCell() }
            guard let otherParametersViewData = presenter?.getOtherParametersViewDataFor(indexPath.row) else { return UITableViewCell() }
            cell.configureWith(viewData: otherParametersViewData)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension DetailWeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = DetailWeatherTableViewSection(sectionIndex: indexPath.section) else {
            return CGFloat()
        }
        switch section {
        case .hourlyForecast:
            return section.cellHeight
        case .dailyForecast:
            return section.cellHeight
        case .todaysDescription:
            return section.cellHeight
        case .otherParameters:
            return section.cellHeight
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        DetailWeatherTableViewSection.numberOfSections
    }
}

// MARK: - UIScrollViewDelegate

extension DetailWeatherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        currentForecastView.setDescriptionFull(offset <= 20)
    }
}

// MARK: - DetailWeatherViewProtocol

extension DetailWeatherViewController: DetailWeatherViewProtocol {
    func reloadCurrentForecastView() {
        guard let viewData = presenter?.currentForecastViewData else { return }
        currentForecastView.configureWith(viewData)
        hideSpinner()
    }
    
    func reloadHourlyForecastSection() {
        weatherTableView.reloadSections(IndexSet(integer: DetailWeatherTableViewSection.hourlyForecast.rawValue),
                                        with: .automatic)
        hideSpinner()
    }
    
    func reloadDailyForecastSection() {
        weatherTableView.reloadSections(IndexSet(integer: DetailWeatherTableViewSection.dailyForecast.rawValue),
                                        with: .automatic)
        hideSpinner()
    }
    
    func reloadTodaysDescriptionSection() {
        weatherTableView.reloadSections(IndexSet(integer: DetailWeatherTableViewSection.todaysDescription.rawValue),
                                        with: .automatic)
        hideSpinner()
    }
    
    func reloadOtherParametersSection() {
        weatherTableView.reloadSections(IndexSet(integer: DetailWeatherTableViewSection.otherParameters.rawValue),
                                        with: .automatic)
        hideSpinner()
    }
}

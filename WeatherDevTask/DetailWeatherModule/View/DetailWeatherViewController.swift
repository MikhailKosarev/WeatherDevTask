//
//  DetailWeatherViewController.swift
//  WeatherDevTask
//
//  Created by Mikhail on 08.12.2022.
//

import UIKit

final class DetailWeatherViewController: UIViewController {
    
    private let currentForecastView = CurrentForecastView()
    
    private let weatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupWeatherTableView()
        setConstraints()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.3048475683, green: 0.598276794, blue: 0.8936008811, alpha: 1)
        view.addSubview(currentForecastView)
        view.addSubview(weatherTableView)
    }
    
    private func setupWeatherTableView() {
        weatherTableView.register(HourlyForecastTableViewCell.self,
                                  forCellReuseIdentifier: HourlyForecastTableViewCell.reuseID)
        weatherTableView.register(DailyForecastTableViewCell.self,
                                  forCellReuseIdentifier: DailyForecastTableViewCell.reuseID)
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
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
        ])
    }
}

// MARK: - UITableViewDataSource

extension DetailWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 7
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = weatherTableView.dequeueReusableCell(withIdentifier: HourlyForecastTableViewCell.reuseID,
                                                            for: indexPath)
            return cell
        case 1:
            let cell = weatherTableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.reuseID,
                                                            for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }

}

// MARK: - UITableViewDelegate

extension DetailWeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 40
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}

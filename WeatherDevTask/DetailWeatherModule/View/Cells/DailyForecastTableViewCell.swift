//
//  DailyForecastTableViewCell.swift
//  WeatherDevTask
//
//  Created by Mikhail on 08.12.2022.
//

import UIKit

final class DailyForecastTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let reuseID = "DailyForecastTableViewCell"
    
    // MARK: - UI properties
    
    private let dayTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let image = WeatherImage.cloudRain
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.humidityLabelTextColor
        return label
    }()
    
    private let dayTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    private let nightTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.5
        label.textAlignment = .right
        return label
    }()
    
    private lazy var weatherHumidityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherImageView,
                                                       humidityLabel])
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var temperatureStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dayTemperatureLabel,
                                                       nightTemperatureLabel])
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var dailyForecastStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dayTitleLabel,
                                                       weatherHumidityStackView,
                                                       temperatureStackView])
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        contentView.addSubview(dailyForecastStackView)
        backgroundColor = .clear
    }
    
    private func setConstraints() {
        // set custom margins
        layoutMargins = UIEdgeInsets(top: 0,
                                     left: 8,
                                     bottom: 0,
                                     right: 8)
        // set priorities
        dayTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        humidityLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            // weatherImageView
            weatherImageView.heightAnchor.constraint(equalToConstant: 30),
            
            // dailyForecastStackView
            dailyForecastStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            dailyForecastStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            dailyForecastStackView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
        ])
    }
    
    // MARK: - Internal methods
    
    func configureWith(viewData: DailyForecastViewData) {
        dayTitleLabel.text = viewData.dayTitle
        weatherImageView.image = viewData.weatherImage
        humidityLabel.text = viewData.humidity
        dayTemperatureLabel.text = viewData.dayTemperature
        nightTemperatureLabel.text = viewData.nightTemperature
    }
}


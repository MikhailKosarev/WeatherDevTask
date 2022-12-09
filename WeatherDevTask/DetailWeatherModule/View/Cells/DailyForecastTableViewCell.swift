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
        label.text = "Tuesday"
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
        label.text = "80%"
        label.textColor = #colorLiteral(red: 0.4862745098, green: 0.8117647059, blue: 0.9764705882, alpha: 1)
        return label
    }()
    
    private let dayTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "14"
        label.textAlignment = .right
        return label
    }()
    
    private let nightTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4"
        label.alpha = 0.5
        label.textAlignment = .right
        return label
    }()
    
    private lazy var dailyForecastStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dayTitleLabel,
                                                       weatherImageView,
                                                       humidityLabel,
                                                       dayTemperatureLabel,
                                                       nightTemperatureLabel])
//        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(4, after: weatherImageView)
        stackView.setCustomSpacing(8, after: dayTemperatureLabel)
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
        
        NSLayoutConstraint.activate([
            // weatherImageView
            weatherImageView.heightAnchor.constraint(equalToConstant: 30),
            weatherImageView.widthAnchor.constraint(equalToConstant: 30),
            
            // dailyForecastStackView
            dailyForecastStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            dailyForecastStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            dailyForecastStackView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
        ])
    }
}

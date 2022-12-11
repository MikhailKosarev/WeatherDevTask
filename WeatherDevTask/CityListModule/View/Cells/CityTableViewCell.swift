//
//  CityTableViewCell.swift
//  WeatherDevTask
//
//  Created by Mikhail on 07.12.2022.
//

import UIKit

final class CityTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let reuseID = "CityTableViewCell"
    
    // MARK: - UI properties
    
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "16:07"
        return label
    }()
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Warsaw"
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let image = WeatherImage.sun
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 50, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "2°"
        label.textAlignment = .right
        return label
    }()
    
    private lazy var cityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentTimeLabel,
                                                       cityNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var weatherStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherImageView,
                                                       temperatureLabel])
//        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cityStackView,
                                                      weatherStackView])
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
        backgroundColor = .black
        contentView.addSubview(mainStackView)
    }
    
    private func setConstraints() {
        // set margins
//        contentView.layoutMargins = .init(top: 8.0, left: 0, bottom: 8.0, right: 0)
        contentView.preservesSuperviewLayoutMargins = false
        let margins = contentView.layoutMarginsGuide
        
        // set priorities
        temperatureLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            // weatherImageView
            weatherImageView.heightAnchor.constraint(equalToConstant: 42),
            weatherImageView.widthAnchor.constraint(equalToConstant: 42),
            
            //mainStackView
            mainStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mainStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
    
    // MARK: - Internal methods
    
    func configureWith(_ viewData: CityCurrentWeatherViewData) {
        currentTimeLabel.text = viewData.currentTime
        cityNameLabel.text = viewData.cityName
        weatherImageView.image = viewData.weatherImage
        temperatureLabel.text = viewData.temperature
    }
}

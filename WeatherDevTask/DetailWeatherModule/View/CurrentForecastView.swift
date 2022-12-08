//
//  CurrentForecastView.swift
//  WeatherDevTask
//
//  Created by Mikhail on 08.12.2022.
//

import UIKit

final class CurrentForecastView: UIView {
    
    // MARK: - UI elements
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 34, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New York"
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 96, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "7°"
        return label
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mostly Cloudy"
        return label
    }()
    
    private let highLowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "H:8° L:0°"
        return label
    }()
    
    private lazy var currentWeatherStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cityNameLabel,
                                                       temperatureLabel,
                                                       weatherDescriptionLabel,
                                                       highLowLabel])
        stackView.axis = .vertical
//        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(currentWeatherStackView)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            currentWeatherStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentWeatherStackView.topAnchor.constraint(equalTo: topAnchor),
            currentWeatherStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            currentWeatherStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

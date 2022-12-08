//
//  HourlyForecastCollectionViewCell.swift
//  WeatherDevTask
//
//  Created by Mikhail on 08.12.2022.
//

import UIKit

final class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static properties
    
    static let reuseID = "HourlyForecastCollectionViewCell"
    
    // MARK: - UI elements
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12pm"
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let image = WeatherImage.cloudSun
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "8°"
        return label
    }()
    
    private lazy var hourlyForecastStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel,
                                                       weatherImageView,
                                                       temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
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
        contentView.addSubview(hourlyForecastStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            // weatherImageView
            weatherImageView.heightAnchor.constraint(equalToConstant: 30),
            weatherImageView.widthAnchor.constraint(equalToConstant: 30),
            
            //hourlyForecastStackView
//            hourlyForecastStackView.topAnchor.constraint(equalTo: margins.topAnchor),
//            hourlyForecastStackView.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
            hourlyForecastStackView.topAnchor.constraint(equalTo: topAnchor),
            hourlyForecastStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

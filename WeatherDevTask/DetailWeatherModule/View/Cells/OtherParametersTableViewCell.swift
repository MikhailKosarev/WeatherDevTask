//
//  OtherParametersTableViewCell.swift
//  WeatherDevTask
//
//  Created by Mikhail on 08.12.2022.
//

import UIKit

final class OtherParametersTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let reuseID = "OtherParametersTableViewCell"
    
    // MARK: - UI properties
    
    private let leftParameterNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SUNRISE"
        label.alpha = 0.5
        return label
    }()
    
    private let leftParameterValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "07:05"
        return label
    }()
    
    private let rightParameterNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SUNSET"
        label.alpha = 0.5
        return label
    }()
    
    private let rightParameterValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "19:05"
        return label
    }()
    
    private lazy var leftParametersStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftParameterNameLabel,
                                                       leftParameterValueLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var rightParametersStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rightParameterNameLabel,
                                                       rightParameterValueLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var otherParametersStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftParametersStackView,
                                                      rightParametersStackView])
        stackView.distribution = .fillEqually
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
        contentView.addSubview(otherParametersStackView)
        backgroundColor = .clear
    }
    
    private func setConstraints() {
        // set custom margins
        layoutMargins = UIEdgeInsets(top: 0,
                                     left: 8,
                                     bottom: 0,
                                     right: 8)
        
        NSLayoutConstraint.activate([
            // dailyForecastStackView
            otherParametersStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            otherParametersStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            otherParametersStackView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
        ])
    }
}


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
    
    private let leftTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "SUNRISE"
        label.alpha = 0.5
        return label
    }()
    
    private let leftValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "07:05"
        return label
    }()
    
    private let rightTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "SUNSET"
        label.alpha = 0.5
        return label
    }()
    
    private let rightValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "19:05"
        return label
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftTitleLabel,
                                                       leftValueLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rightTitleLabel,
                                                       rightValueLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var otherParametersStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftStackView,
                                                      rightStackView])
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
    
    // MARK: - Internal methods
    
    func configureWith(viewData: OtherParametersViewData) {
        leftTitleLabel.text = viewData.leftTitle
        leftValueLabel.text = viewData.leftValue
        rightTitleLabel.text = viewData.rightTitle
        rightValueLabel.text = viewData.rightValue
    }
}


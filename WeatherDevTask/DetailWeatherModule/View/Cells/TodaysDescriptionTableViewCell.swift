//
//  TodaysDescriptionTableViewCell.swift
//  WeatherDevTask
//
//  Created by Mikhail on 08.12.2022.
//

import UIKit

final class TodaysDescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let reuseID = "TodaysDescriptionTableViewCell"
    
    // MARK: - UI properties
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Cloudy conditions will continue all day. Wind gusts are up ti 9 mph."
        label.numberOfLines = 0
        return label
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
        contentView.addSubview(descriptionLabel)
        backgroundColor = .clear
    }
    
    private func setConstraints() {
        // set custom margins
        layoutMargins = UIEdgeInsets(top: 0,
                                     left: 8,
                                     bottom: 0,
                                     right: 8)
        
        NSLayoutConstraint.activate([
            // descriptionLabel
            descriptionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Internal methods
    
    func configureWith(viewData: TodaysDescriptionViewData) {
        descriptionLabel.text = viewData.description
    }
}

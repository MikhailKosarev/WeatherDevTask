//
//  HourlyForecastTableViewCell.swift
//  WeatherDevTask
//
//  Created by Mikhail on 08.12.2022.
//

import UIKit

final class HourlyForecastTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let reuseID = "HourlyForecastTableViewCell"
    
    // MARK: - UI properties
    
    private let hourlyForecastCollectionView: UICollectionView = {
        // setup flow
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        // setup collectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = .init(top: 0,
                                            left: 8,
                                            bottom: 0,
                                            right: 8)
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupHourlyForecastCollectionView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        contentView.addSubview(hourlyForecastCollectionView)
        backgroundColor = .clear
    }
    
    private func setupHourlyForecastCollectionView() {
        hourlyForecastCollectionView.dataSource = self
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.register(HourlyForecastCollectionViewCell.self,
                                              forCellWithReuseIdentifier: HourlyForecastCollectionViewCell.reuseID)
    }
    
    private func setConstraints() {
//        let safeArea = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // hourlyForecastCollectionView
            hourlyForecastCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hourlyForecastCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hourlyForecastCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hourlyForecastCollectionView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension HourlyForecastTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hourlyForecastCollectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.reuseID,
                                                                    for: indexPath)
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate

extension HourlyForecastTableViewCell: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HourlyForecastTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: collectionView.frame.height)
    }
}

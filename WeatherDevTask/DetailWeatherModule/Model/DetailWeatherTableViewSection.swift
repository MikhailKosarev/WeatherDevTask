//
//  DetailWeatherTableViewSection.swift
//  WeatherDevTask
//
//  Created by Mikhail on 11.12.2022.
//

import UIKit

enum DetailWeatherTableViewSection: Int {
    static let numberOfSections = 4
    
    case hourlyForecast = 0
    case dailyForecast = 1
    case todaysDescription = 2
    case otherParameters = 3
    
    init?(sectionIndex: Int) {
        guard let section = DetailWeatherTableViewSection(rawValue: sectionIndex) else {
            return nil
        }
        self = section
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .hourlyForecast:
            return CGFloat(100)
        case .dailyForecast:
            return CGFloat(40)
        case .todaysDescription:
            return CGFloat(66)
        case .otherParameters:
            return CGFloat(66)
        }
    }
}


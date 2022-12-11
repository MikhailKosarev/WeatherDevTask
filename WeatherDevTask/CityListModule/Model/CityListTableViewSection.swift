//
//  CityListTableViewSection.swift
//  WeatherDevTask
//
//  Created by Mikhail on 11.12.2022.
//

import UIKit

enum CityListTableViewSection: Int {
    static let numberOfSections = 2
    
    case searchSection = 0
    case cityListSection = 1
    
    init?(sectionIndex: Int) {
        guard let section = CityListTableViewSection(rawValue: sectionIndex) else {
            return nil
        }
        self = section
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .searchSection:
            return CGFloat(100)
        case .cityListSection:
            return CGFloat(40)
        }
    }
}

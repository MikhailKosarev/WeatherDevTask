//
//  Constants.swift
//  WeatherDevTask
//
//  Created by Mikhail on 07.12.2022.
//

import UIKit

struct WeatherImage {
    static let sun = UIImage(named: "sunImage")
    static let cloudSun = UIImage(named: "cloudSunImage")
    static let cloud = UIImage(named: "cloudImage")
    static let cloudRain = UIImage(named: "cloudRainImage")
    static let cloudBolt = UIImage(named: "cloudBoltImage")
    static let snow = UIImage(named: "snowImage")
    static let fog = UIImage(named: "fogImage")
}

struct Constants {
    static let otherParametersDefaultArray = [OtherParametersViewData(leftTitle: "SUNRISE",
                                                               rightTitle: "SUNSET"),
                                       OtherParametersViewData(leftTitle: "CHANCE OF RAIN",
                                                               rightTitle: "HUMIDITY"),
                                       OtherParametersViewData(leftTitle: "WIND",
                                                               rightTitle: "FEELS LIKE"),
                                       OtherParametersViewData(leftTitle: "PRECIPITATION",
                                                               rightTitle: "PRESSURE"),
                                       OtherParametersViewData(leftTitle: "VISIBILITY",
                                                               rightTitle: "UV INDEX")
    ]
}

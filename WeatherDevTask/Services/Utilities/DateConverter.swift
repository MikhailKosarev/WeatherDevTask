//
//  DateConverter.swift
//  WeatherDevTask
//
//  Created by Mikhail on 10.12.2022.
//

import Foundation

struct DateConverter {
    func convertingUTCtime(_ dt: Int) -> Date {
        let timeInterval = TimeInterval(dt)
        let utcTime = Date(timeIntervalSince1970: timeInterval)
        return utcTime
    }
}

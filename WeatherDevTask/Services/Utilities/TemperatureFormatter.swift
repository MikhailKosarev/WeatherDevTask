//
//  TemperatureFormatter.swift
//  WeatherDevTask
//
//  Created by Mikhail on 11.12.2022.
//

import UIKit

struct TemperatureFormatter {
    static func getStringTemperatureFrom(_ temperature: Double) -> String {
        let temperature = String(format: "%.0f", temperature) + "°"
        return temperature.replacingOccurrences(of: "-0", with: "0")
    }
    static func getStringTemperatureWithoutDegreeSignFrom(_ temperature: Double) -> String {
        let temperature = String(format: "%.0f", temperature)
        return temperature.replacingOccurrences(of: "-0", with: "0")
    }
}

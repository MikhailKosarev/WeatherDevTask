//
//  TemperatureFormatter.swift
//  WeatherDevTask
//
//  Created by Mikhail on 11.12.2022.
//

import UIKit

struct TemperatureFormatter {
    static func getStringTemperatureFrom(_ temperature: Double) -> String {
        return String(format: "%.0f", temperature) + "°".replacingOccurrences(of: "-0", with: "0")
    }
}

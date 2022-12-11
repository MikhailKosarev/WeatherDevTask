//
//  CurrentWeatherViewData.swift
//  WeatherDevTask
//
//  Created by Mikhail on 10.12.2022.
//

import UIKit

struct CurrentForecastViewData {
    let cityName: String
    let currentTemperature: Double
    let weatherDescription: String
    let highTemperature: Double
    let lowTemperature: Double
    
    var currentTemperatureString: String {
        return String(format: "%.0f", currentTemperature) + "°"
    }
    
    var highLowTemperatureString: String {
        let highTemperatureString = String(format: "%.0f", highTemperature) + "°"
        let lowTemperatureString = String(format: "%.0f", lowTemperature) + "°"
        return "H:" + highTemperatureString + " L:" + lowTemperatureString
    }
    
    var shortWeatherDescription: String {
        return currentTemperatureString + " | " + weatherDescription
    }
}

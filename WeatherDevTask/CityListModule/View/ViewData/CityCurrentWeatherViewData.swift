//
//  CityCurrentWeatherViewData.swift
//  WeatherDevTask
//
//  Created by Mikhail on 09.12.2022.
//

import UIKit

struct CityCurrentWeatherViewData {
    let currentTime: String
    let cityName: String
    let temperature: Double
    let conditionId: Int
    
    var temperatureString: String {
        return String(format: "%.0f", temperature) + "°"
    }
    
    var weatherImage: UIImage? {
        switch conditionId {
        // Group 2xx: Thunderstorm
        case 200...202, 230...232:
            return WeatherImage.cloudBolt
        case 210...221:
            return WeatherImage.cloudBolt
        // Group 3xx: Drizzle
        case 300...321:
            return WeatherImage.cloudRain
        // Group 5xx: Rain
        case 500...531:
            return WeatherImage.cloudRain
        // Group 6xx: Snow
        case 600...602:
            return WeatherImage.cloudRain
        case 611...622:
            return WeatherImage.cloudRain
        // Group 7xx: Atmosphere
        case 701...781:
            return WeatherImage.fog
        // Group 800: Clear
        case 800:
            return WeatherImage.sun
        // Group 80x: Clouds
        case 801...802:
            return WeatherImage.cloudSun
        case 803...804:
            return WeatherImage.cloud
        default:
            return WeatherImage.cloud
        }
    }
}

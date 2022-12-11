//
//  DetailWeatherPresenter.swift
//  WeatherDevTask
//
//  Created by Mikhail on 10.12.2022.
//

import UIKit

// MARK: - DetailWeatherViewProtocol

protocol DetailWeatherViewProtocol: UIViewController {
    func reloadCurrentForecastView()
    func reloadTableView()
}

// MARK: - DetailWeatherPresenterProtocol

protocol DetailWeatherPresenterProtocol: AnyObject {
    // properties
    var currentForecastData: CurrentForecastViewData? { get set }
    var hourlyForecastData: [HourlyForecastViewData] { get set }
    var dailyForecastData: [DailyForecastViewData] { get set }
    var todaysDescriptionData: TodaysDescriptionViewData? { get set }
    var otherParametersViewData: [OtherParametersViewData] { get set }
    
    // initialization
    init(view: DetailWeatherViewProtocol, networkService: NetworkServiceProtocol)
    
    // methods
    func getWeatherFor(city: String?)
}

// MARK: - CityListPresenter

final class DetailWeatherPresenter: DetailWeatherPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: DetailWeatherViewProtocol?
    var networkService: NetworkServiceProtocol
    
    let locationGeocoder = LocationGeocoder()
    var currentForecastData: CurrentForecastViewData?
    var hourlyForecastData = [HourlyForecastViewData]()
    var dailyForecastData = [DailyForecastViewData]()
    var todaysDescriptionData: TodaysDescriptionViewData?
    var otherParametersViewData = Constants.otherParametersDefaultArray
    
    let dateConverter = DateConverter()
    
    // MARK: - Initialization
    
    init(view: DetailWeatherViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    // MARK: - Internal methods
    
    func getWeatherFor(city: String?) {
        guard let city else { return }
        locationGeocoder.getCoordinateOf(city) { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            self.networkService.getWeatherData(lon: String(coordinate.longitude),
                                               lat: String(coordinate.latitude)) { result in
                switch result {
                case .success(let weatherData):
//                     get current time
//                                        let currentTime = self.dateConverter.convertingUTCtime(weatherData.current.dt)
//                                            .currentTime(weatherData.timezoneOffset)
//                                        print(currentTime)
//
//                  // fill currentWeatherViewData
                    self.fillCurrentForecastViewDataWith(weatherData, city: city)
                    self.view?.reloadCurrentForecastView()

                    // fill hourlyForecastViewData
                    self.fillHourlyForecastViewDataWith(weatherData, hours: 24)
                    
                    // fill weeklyForecastData
                    self.fillDailyForecastViewDataWith(weatherData, days: 8)
                    
                    // fill todaysDescription
                    self.fillTodaysDescriptionViewDataWith(weatherData)

                    // fill otherParametersData
                    self.fillOtherParametersViewDataWith(weatherData)
 
                    // MARK: - reloadTableView()
                    self.view?.reloadTableView()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func fillCurrentForecastViewDataWith(_ weatherData: OneCallWeatherData,
                                                 city: String) {
        self.currentForecastData = CurrentForecastViewData(cityName: city,
                                                         currentTemperature: weatherData.current.temp,
                                                           weatherDescription: weatherData.current.weather[0].main,
                                                         highTemperature: weatherData.daily[0].temp.max,
                                                         lowTemperature: weatherData.daily[0].temp.min)
    }
    
    private func fillHourlyForecastViewDataWith(_ weatherData: OneCallWeatherData,
                                                hours: Int) {
        // check index out of range
        let maxHours = max(hours, weatherData.hourly.count)
        for index in 0..<maxHours {
            let hourly = weatherData.hourly[index]
            // get time
            let time = self.dateConverter.convertingUTCtime(hourly.dt).dtToTime12Hours(weatherData.timezoneOffset)
            // fill data
            let viewData = HourlyForecastViewData(time: time,
                                                  conditionId: hourly.weather[0].id,
                                                  temperature: hourly.temp)
            self.hourlyForecastData.append(viewData)
        }
    }
    
    private func fillDailyForecastViewDataWith(_ weatherData: OneCallWeatherData,
                                               days: Int) {
        // check index out of range
        let maxDays = max(days, weatherData.daily.count)
        // excluding today
        for index in 1..<maxDays {
            let daily = weatherData.daily[index]
            // get day of week
            let dayOfWeek = self.dateConverter.convertingUTCtime(daily.dt).dtToDayOfWeek(weatherData.timezoneOffset)
            // fill data
            let viewData = DailyForecastViewData(dayTitle: dayOfWeek,
                                                 conditionId: daily.weather[0].id,
                                                 humidity: daily.humidity,
                                                 dayTemperature: daily.temp.day,
                                                 nightTemperature: daily.temp.night)
            self.dailyForecastData.append(viewData)
        }
    }
    
    private func fillTodaysDescriptionViewDataWith(_ weatherData: OneCallWeatherData) {
        self.todaysDescriptionData = TodaysDescriptionViewData(description: weatherData.current.weather[0].weatherDescription)
    }
    
    private func fillOtherParametersViewDataWith(_ weatherData: OneCallWeatherData) {
        // fill sunrise/sunset
        if let sunrise = weatherData.current.sunrise {
            let sunriseTime = self.dateConverter.convertingUTCtime(sunrise).currentTime(weatherData.timezoneOffset)
            self.otherParametersViewData[0].leftValue = sunriseTime
        } else {
            self.otherParametersViewData[0].leftValue = "no data"
        }
        
        if let sunset = weatherData.current.sunset {
            let sunsetTime = self.dateConverter.convertingUTCtime(sunset).currentTime(weatherData.timezoneOffset)
            self.otherParametersViewData[0].rightValue = sunsetTime
        } else {
            self.otherParametersViewData[0].rightValue = "no data"
        }
        
        // fill chance of rain/humidity
        self.otherParametersViewData[1].leftValue = "no data"
        let humidity = String(weatherData.current.humidity) + "%"
        self.otherParametersViewData[1].rightValue = humidity
        
        // fill wind/feels like
        let wind = String(weatherData.current.windSpeed) + " m/s"
        self.otherParametersViewData[2].leftValue = wind
        let feelsLike = String(weatherData.current.feelsLike) + "°"
        self.otherParametersViewData[2].rightValue = feelsLike
        
        // fill precipitation/pressure
        self.otherParametersViewData[3].leftValue = "no data"
        let pressure = String(weatherData.current.pressure) + "hPa"
        self.otherParametersViewData[3].rightValue = pressure
        
        // fill visibility/uv index
        let visibility = String(weatherData.current.visibility / 1000) + " km"
        self.otherParametersViewData[4].leftValue = visibility
        let uvIndex = String(weatherData.current.uvi)
        self.otherParametersViewData[4].rightValue = uvIndex
    }
}

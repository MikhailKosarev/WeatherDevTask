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
    func reloadHourlyForecastSection()
    func reloadDailyForecastSection()
    func reloadTodaysDescriptionSection()
    func reloadOtherParametersSection()
}

// MARK: - DetailWeatherPresenterProtocol

protocol DetailWeatherPresenterProtocol: AnyObject {
    // properties
    var currentForecastViewData: CurrentForecastViewData? { get set }
    var hourlyForecastViewData: [HourlyForecastViewData] { get set }
    var dailyForecastViewData: [DailyForecastViewData] { get set }
    var todaysDescriptionViewData: TodaysDescriptionViewData? { get set }
    var otherParametersViewData: [OtherParametersViewData] { get set }
    
    // initialization
    init(view: DetailWeatherViewProtocol, networkService: NetworkServiceProtocol)
    
    // MARK: Methods
    
    //get numbers for row
    func getNumberOfHourlyForecastRows() -> Int
    func getNumberOfDailyForecastRows() -> Int
    func getNumberOfTodaysDescriptionRows() -> Int
    func getNumberOfOtherParametersRows() -> Int
    
    // get weather
    func getWeatherFor(city: String?)
    
    // get viewData
    func getHourlyForecastData() -> [HourlyForecastViewData]
    func getDailyForecastDataFor(_ index: Int) -> DailyForecastViewData
    func getTodaysDescriptionData() -> TodaysDescriptionViewData?
    func getOtherParametersViewDataFor(_ index: Int) -> OtherParametersViewData
}

// MARK: - CityListPresenter

final class DetailWeatherPresenter: DetailWeatherPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: DetailWeatherViewProtocol?
    var networkService: NetworkServiceProtocol
    
    let locationGeocoder = LocationGeocoder()
    var currentForecastViewData: CurrentForecastViewData?
    var hourlyForecastViewData = [HourlyForecastViewData]()
    var dailyForecastViewData = [DailyForecastViewData]()
    var todaysDescriptionViewData: TodaysDescriptionViewData?
    var otherParametersViewData = [OtherParametersViewData]()
    
    let dateConverter = DateConverter()
    
    // MARK: - Initialization
    
    init(view: DetailWeatherViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    // MARK: - Internal methods
    func getNumberOfHourlyForecastRows() -> Int {
        // always one row with collectionView
        return hourlyForecastViewData.isEmpty ? 0 : 1
    }
    
    func getNumberOfDailyForecastRows() -> Int {
        return dailyForecastViewData.count
    }
    
    func getNumberOfTodaysDescriptionRows() -> Int {
        // always one row
        return todaysDescriptionViewData == nil ? 0 : 1
    }
    
    func getNumberOfOtherParametersRows() -> Int {
        return otherParametersViewData.count
    }
    
    func getWeatherFor(city: String?) {
        guard let city else { return }
        locationGeocoder.getCoordinateOf(city) { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            self.networkService.getWeatherData(lon: String(coordinate.longitude),
                                               lat: String(coordinate.latitude)) { result in
                switch result {
                case .success(let weatherData):
                    // fill currentWeatherViewData
                    self.fillCurrentForecastViewDataWith(weatherData, city: city)
                    self.view?.reloadCurrentForecastView()
                    
                    // fill hourlyForecastViewData
                    self.fillHourlyForecastViewDataWith(weatherData, hours: 24)
                    self.view?.reloadHourlyForecastSection()
                    
                    // fill weeklyForecastData
                    self.fillDailyForecastViewDataWith(weatherData, days: 8)
                    self.view?.reloadDailyForecastSection()
                    
                    // fill todaysDescription
                    self.fillTodaysDescriptionViewDataWith(weatherData)
                    self.view?.reloadTodaysDescriptionSection()
                    
                    // fill otherParametersData
                    self.fillOtherParametersViewDataWith(weatherData)
                    self.view?.reloadOtherParametersSection()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getHourlyForecastData() -> [HourlyForecastViewData] {
        return hourlyForecastViewData
    }
    
    func getDailyForecastDataFor(_ index: Int) -> DailyForecastViewData {
        return dailyForecastViewData[index]
    }
    
    func getTodaysDescriptionData() -> TodaysDescriptionViewData? {
        return todaysDescriptionViewData
    }
    
    func getOtherParametersViewDataFor(_ index: Int) -> OtherParametersViewData {
        return otherParametersViewData[index]
    }
    
    // MARK: - Private methods
    
    private func fillCurrentForecastViewDataWith(_ weatherData: OneCallWeatherData,
                                                 city: String) {
        let currentTemperature = TemperatureFormatter.getStringTemperatureFrom(weatherData.current.temp)
        let highTemperature = TemperatureFormatter.getStringTemperatureFrom(weatherData.daily[0].temp.max)
        let lowTemperature = TemperatureFormatter.getStringTemperatureFrom(weatherData.daily[0].temp.min)
        let highLowTemperature = "H:" + highTemperature + " L:" + lowTemperature
        let shortWeatherDescription = currentTemperature + " | " + weatherData.current.weather[0].main
        
        self.currentForecastViewData = CurrentForecastViewData(cityName: city,
                                                           currentTemperature: currentTemperature,
                                                           weatherDescription: weatherData.current.weather[0].main,
                                                           highLowTemperature: highLowTemperature,
                                                           shortWeatherDescription: shortWeatherDescription)
    }
    
    private func fillHourlyForecastViewDataWith(_ weatherData: OneCallWeatherData,
                                                hours: Int) {
        // check index out of range
        let minHours = min(hours, weatherData.hourly.count)
        for index in 0..<minHours {
            let hourly = weatherData.hourly[index]
            // get time
            let time = self.dateConverter.convertingUTCtime(hourly.dt).dtToTime12Hours(weatherData.timezoneOffset)
            let temperature = TemperatureFormatter.getStringTemperatureFrom(hourly.temp)
            // fill data
            let weatherImage = WeatherImageConverter.getImage(from: hourly.weather[0].id)
            let viewData = HourlyForecastViewData(time: time,
                                                  temperature: temperature,
                                                  weatherImage: weatherImage)
            self.hourlyForecastViewData.append(viewData)
        }
    }
    
    private func fillDailyForecastViewDataWith(_ weatherData: OneCallWeatherData,
                                               days: Int) {
        // check index out of range
        let minDays = min(days, weatherData.daily.count)
        // excluding today
        for index in 1..<minDays {
            let daily = weatherData.daily[index]
            // get day of week
            let dayOfWeek = self.dateConverter.convertingUTCtime(daily.dt).dtToDayOfWeek(weatherData.timezoneOffset)
            let weatherImage = WeatherImageConverter.getImage(from: daily.weather[0].id)
            let humidity = String(daily.humidity) + Units.percentage
            let dayTemperature = TemperatureFormatter.getStringTemperatureWithoutDegreeSignFrom(daily.temp.day)
            let nightTemperature = TemperatureFormatter.getStringTemperatureWithoutDegreeSignFrom(daily.temp.night)
            // fill data
            let viewData = DailyForecastViewData(dayTitle: dayOfWeek,
                                                 weatherImage: weatherImage,
                                                 humidity: humidity,
                                                 dayTemperature: dayTemperature,
                                                 nightTemperature: nightTemperature)
            self.dailyForecastViewData.append(viewData)
        }
    }
    
    private func fillTodaysDescriptionViewDataWith(_ weatherData: OneCallWeatherData) {
        self.todaysDescriptionViewData = TodaysDescriptionViewData(description: "There will be " + weatherData.current.weather[0].weatherDescription + " all the day")
    }
    
    private func fillOtherParametersViewDataWith(_ weatherData: OneCallWeatherData) {
        // set titles
        otherParametersViewData = Constants.otherParametersDefaultArray
        
        // fill sunrise/sunset
        if let sunrise = weatherData.current.sunrise {
            let sunriseTime = self.dateConverter.convertingUTCtime(sunrise).currentTime(weatherData.timezoneOffset)
            self.otherParametersViewData[0].leftValue = sunriseTime
        } else {
            self.otherParametersViewData[0].leftValue = Units.noData
        }
        
        if let sunset = weatherData.current.sunset {
            let sunsetTime = self.dateConverter.convertingUTCtime(sunset).currentTime(weatherData.timezoneOffset)
            self.otherParametersViewData[0].rightValue = sunsetTime
        } else {
            self.otherParametersViewData[0].rightValue = Units.noData
        }
        
        // fill chance of rain/humidity
        self.otherParametersViewData[1].leftValue = Units.noData
        let humidity = String(weatherData.current.humidity) + Units.percentage
        self.otherParametersViewData[1].rightValue = humidity
        
        // fill wind/feels like
        let wind = String(weatherData.current.windSpeed) + " " + Units.metreSec
        self.otherParametersViewData[2].leftValue = wind
        let feelsLike = TemperatureFormatter.getStringTemperatureFrom(weatherData.current.feelsLike)
        self.otherParametersViewData[2].rightValue = feelsLike
        
        // fill precipitation/pressure
        self.otherParametersViewData[3].leftValue = Units.noData
        let pressure = String(weatherData.current.pressure) + Units.hPa
        self.otherParametersViewData[3].rightValue = pressure
        
        // fill visibility/uv index
        let visibility = String(weatherData.current.visibility / 1000) + " " + Units.kilometers
        self.otherParametersViewData[4].leftValue = visibility
        let uvIndex = String(weatherData.current.uvi)
        self.otherParametersViewData[4].rightValue = uvIndex
    }
}

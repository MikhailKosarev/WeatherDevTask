//
//  CityListPresenter.swift
//  WeatherDevTask
//
//  Created by Mikhail on 09.12.2022.
//

import UIKit

// MARK: - CityListViewProtocol

protocol CityListViewProtocol: UIViewController {
    // methods
    func reloadCityListSection()
}

// MARK: - CityListPresenterProtocol

protocol CityListPresenterProtocol: AnyObject {
    // properties
    var citiesArray: [String] { get }
    var weatherDataArray: [CityCurrentWeatherViewData] { get set }
    var filteredWeatherDataArray: [CityCurrentWeatherViewData] { get set }
    
    // initialization
    init(view: CityListViewProtocol, networkService: NetworkServiceProtocol)

    // methods
    func getNumberOfCities() -> Int
    func getViewDataFor(_ index: Int) -> CityCurrentWeatherViewData
    func getWeather()
    func filterCitiesStarting(with searchText: String)
}

// MARK: - CityListPresenter

final class CityListPresenter: CityListPresenterProtocol {

    // MARK: - Properties
    
    weak var view: CityListViewProtocol?
    var networkService: NetworkServiceProtocol
    
    let locationGeocoder = LocationGeocoder()
    let citiesArray = ["Warsaw", "Bucharest", "Budapest"]
    var weatherDataArray = [CityCurrentWeatherViewData]()
    var filteredWeatherDataArray = [CityCurrentWeatherViewData]()
    let dateConverter = DateConverter()
    
    // MARK: - Initialization
    
    init(view: CityListViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    // MARK: - Protocol methods
    
    func getNumberOfCities() -> Int {
        return filteredWeatherDataArray.count
    }
    
    func getViewDataFor(_ index: Int) -> CityCurrentWeatherViewData {
        return filteredWeatherDataArray[index]
    }
    
    func getWeather() {
        let dispatchGroup = DispatchGroup()
        citiesArray.forEach { city in
            // handle multiple dependent requests in parallel
            dispatchGroup.enter()
            locationGeocoder.getCoordinateOf(city) { coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                self.networkService.getWeatherData(lon: String(coordinate.longitude),
                                                   lat: String(coordinate.latitude)) { result in
                    switch result {
                    case .success(let weatherData):
                        // fill viewData
                        self.fillViewDataWith(weatherData, for: city)
                        dispatchGroup.leave()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.filteredWeatherDataArray = self.weatherDataArray
            self.view?.reloadCityListSection()
        }
    }
    
    func filterCitiesStarting(with searchText: String) {
        filteredWeatherDataArray = weatherDataArray.filter { city in
            city.cityName.hasPrefix(searchText)
        }
        self.view?.reloadCityListSection()
    }
    
    // MARK: - Private methods
    
    private func fillViewDataWith(_ weatherData: OneCallWeatherData, for city: String) {
        // get current time
        let currentTime = self.dateConverter.convertingUTCtime(weatherData.current.dt)
            .currentTime(weatherData.timezoneOffset)
        // fill viewData
        guard let weatherImage = WeatherImageConverter.getImage(from: weatherData.current.weather[0].id) else { return }
        let temperature = String(format: "%.0f", weatherData.current.temp) + "°"
            .replacingOccurrences(of: "-0", with: "0")
        let viewData = CityCurrentWeatherViewData(currentTime: currentTime,
                                                  cityName: city,
                                                  temperature: temperature,
                                                  weatherImage: weatherImage
        )
        // add viewData to weatherDataArray
        self.weatherDataArray.append(viewData)
    }
}

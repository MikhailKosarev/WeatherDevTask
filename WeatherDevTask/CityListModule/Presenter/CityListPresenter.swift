//
//  CityListPresenter.swift
//  WeatherDevTask
//
//  Created by Mikhail on 09.12.2022.
//

import UIKit

// MARK: - CityListViewProtocol

protocol CityListViewProtocol: UIViewController {
    func loadWeather(viewData: CityCurrentWeatherViewData)
    func reloadTableView()
}

// MARK: - CityListPresenterProtocol

protocol CityListPresenterProtocol: AnyObject {
    var citiesArray: [String] { get }
    var weatherDataArray: [CityCurrentWeatherViewData] { get set }
    init(view: CityListViewProtocol, networkService: NetworkServiceProtocol)

    func getWeather()
}

// MARK: - CityListPresenter

final class CityListPresenter: CityListPresenterProtocol {

    // MARK: - Properties
    
    weak var view: CityListViewProtocol?
    var networkService: NetworkServiceProtocol
    
    let locationGeocoder = LocationGeocoder()
    let citiesArray = ["Warsaw","Bucharest","Martuni","Shah Alam","Budapest","Munich"]
    var weatherDataArray = [CityCurrentWeatherViewData]()
    let dateConverter = DateConverter()
    
    // MARK: - Initialization
    
    init(view: CityListViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    // MARK: - Internal methods
    
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
                        // get current time
                        let currentTime = self.dateConverter.convertingUTCtime(weatherData.current.dt)
                            .currentTime(weatherData.timezoneOffset)
                        print(currentTime)
                        // fill viewData
                        let viewData = CityCurrentWeatherViewData(currentTime: currentTime,
                                                                  cityName: city,
                                                                  temperature: weatherData.current.temp,
                                                                  conditionId: weatherData.current.weather[0].id)
                        print()
                        self.weatherDataArray.append(viewData)
                        dispatchGroup.leave()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.view?.reloadTableView()
        }
    }
}

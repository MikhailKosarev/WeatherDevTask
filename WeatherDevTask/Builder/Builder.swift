//
//  File.swift
//  WeatherDevTask
//
//  Created by Mikhail on 09.12.2022.
//

import UIKit

protocol Builder {
    static func createCityListModule() -> UIViewController
}

final class ModuleBulder: Builder {
    static func createCityListModule() -> UIViewController {
        let view = CityListViewController()
        let networkService = NetworkService()
        let presenter = CityListPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
    
    static func createDetailWeatherModule() -> UIViewController {
        let view = DetailWeatherViewController()
        let networkService = NetworkService()
        let presenter = DetailWeatherPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
}

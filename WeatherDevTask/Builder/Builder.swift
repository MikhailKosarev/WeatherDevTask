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
        return view
    }
}

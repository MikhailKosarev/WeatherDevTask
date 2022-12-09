//
//  NetworkServices.swift
//  WeatherDevTask
//
//  Created by Mikhail on 09.12.2022.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol: AnyObject {
    func getWeatherData(lon: String,
                        lat: String,
                        completion: @escaping(Result<OneCallWeatherData, Error>) -> Void)
}


final class NetworkService: NetworkServiceProtocol {
    func getWeatherData(lon: String,
                        lat: String,
                        completion: @escaping(Result<OneCallWeatherData, Error>) -> Void) {
        let parameters: [String: String] = [
            "lon": "\(lon)",
            "lat": "\(lat)",
            "appid": "\(WeatherApiInfo.apiID)"
        ]
        
        AF.request(WeatherApiInfo.weatherBaseURL,
                   method: .get,
                   parameters:  parameters
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: OneCallWeatherData.self) { response in
            if let error = response.error {
                completion(.failure(error))
            }
            guard let data = response.value else { return }
            completion(.success(data))
        }
    }
}

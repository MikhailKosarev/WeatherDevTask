//
//  CoreLocationGeocoder.swift
//  WeatherDevTask
//
//  Created by Mikhail on 09.12.2022.
//

import CoreLocation

final class LocationGeocoder {
    func getCoordinateOf(city: String,
                         completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(city) {
            completion($0?.first?.location?.coordinate, $1)
        }
    }
}

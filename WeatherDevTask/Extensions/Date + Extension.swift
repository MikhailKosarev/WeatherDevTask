//
//  Date + Extension.swift
//  WeatherDevTask
//
//  Created by Mikhail on 10.12.2022.
//

import Foundation

extension Date {
    func dtToDayOfWeek(_ timezone: Int ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormatter.locale = Locale(identifier: "en-GB")
        return dateFormatter.string(from: self)
    }
    
    func dtToTime12Hours(_ timezone: Int ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ha"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        return dateFormatter.string(from: self)
    }
    
    func currentTime(_ timezone: Int ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        return dateFormatter.string(from: self)
    }
}

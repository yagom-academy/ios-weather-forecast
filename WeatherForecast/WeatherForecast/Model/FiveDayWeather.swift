//
//  FiveDayWeather.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/09/28.
//

import Foundation

struct FiveDayWeather: Decodable {
    let cod: String
    let message: Double
    let timestampCount: Int
    let list: [List]
    let city: City
    
    struct List: Decodable {
        let UnixForecastTime: Int
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let rain: Rain?
        let sys: Sys
        let ISOForecastTime: String
    }
    
    struct City: Decodable {
        let id: Int
        let name: String
        let coordinates: Coordinates
        let county: String
    }
    
    struct Rain: Decodable {
        let threeHoursVolume: Double
    }
    
    struct Sys: Decodable {
        let partOfDay: String
    }
}

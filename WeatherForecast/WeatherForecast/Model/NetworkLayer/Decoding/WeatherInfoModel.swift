//
//  WeatherInfoModel.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/29.
//

import Foundation

struct CurrentWeather: Decodable {
    var weather: [WeatherDetail]
}

struct WeatherDetail: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct FiveDaysForecast: Decodable {
    var list: [ListDetail]
    
    struct ListDetail: Decodable {
        var weather: [WeatherDetail]
    }
}

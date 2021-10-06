//
//  WeatherInfoModel.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/29.
//

import Foundation

struct FiveDaysForecast: Decodable {
    var list: [ListDetail]
}

struct ListDetail: Decodable {
    var date: Int
    var main: MainDetail
    var weather: [WeatherDetail]

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main, weather
    }
}

struct MainDetail: Decodable {
    var temperature: Double

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}

struct WeatherDetail: Decodable {
    var icon: String
}


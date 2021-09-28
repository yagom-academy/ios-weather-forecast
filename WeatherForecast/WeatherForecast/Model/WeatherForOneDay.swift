//
//  WeatherForOneDay.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/09/28.
//

import Foundation

struct WeatherForOneDay: Decodable {
    let coordinate: Coordinate?
    let weatherConditionCodes: [Weather]?
    let base: String?
    let mainWeatherInfomation: MainWeatherInformation?
    let visibleDistance: Int?
    let windInformation: Wind?
    let cloudsInformation: Clouds?
    let snowInformation: Snow?
    let rainInformation: Rain?
    let timeOfDataCalculation: TimeInterval?
    let timeOfDataForecasted: String?
    let sys: System?
    let timezone: Int?
    let cityId: Int?
    let cityName: String?
    let statusCode: Int?
    let probabilityOfPrecipitation: Double?
    
    enum CodingKeys: String, CodingKey {
        case base, sys, timezone
        case coordinate = "coord"
        case weatherConditionCodes = "weather"
        case mainWeatherInfomation = "main"
        case visibleDistance = "visibility"
        case windInformation = "wind"
        case cloudsInformation = "clouds"
        case snowInformation = "snow"
        case rainInformation = "rain"
        case timeOfDataCalculation = "dt"
        case timeOfDataForecasted = "dt_txt"
        case cityId = "id"
        case cityName = "name"
        case statusCode = "cod"
        case probabilityOfPrecipitation = "pop"
    }
}

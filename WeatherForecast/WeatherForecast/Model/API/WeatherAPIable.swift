//
//  WeatherAPIable.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/09/28.
//

import Foundation

protocol WeatherAPIable: APIable {
    var callType: CallType { get }
    var forecastType: ForecastType { get }
}

enum CallType {
    case cityName(cityName: String, parameter: CommonWeatherAPIParameter?)
    case cityID(cityID: Int, parameter: CommonWeatherAPIParameter?)
    case geographicCoordinates(coordinate: Coordinate, parameter: CommonWeatherAPIParameter?)
    case ZIPCode(ZIPCode: Int, parameter: CommonWeatherAPIParameter?)
}

enum ForecastType {
    case current
    case fiveDays
    
    var baseURL: String {
        switch self {
        case .current:
            return "api.openweathermap.org/data/2.5/weather"
        case .fiveDays:
            return "api.openweathermap.org/data/2.5/forecast"
        }
    }
}

struct CommonWeatherAPIParameter {
    let responseFormat: ContentType?
    let numberOfTimestamps: Int?
    let unitsOfMeasurement: MeasurementType?
    let language: LanguageType?
    
    func generateURLQueryItems() -> [URLQueryItem] {
        let modeItem = generateURLQueryItem(name: "mode",
                                            value: responseFormat?.formatValue as Any)
        let cntItem = generateURLQueryItem(name: "cnt",
                                           value: numberOfTimestamps?.description as Any)
        let unitsItem = generateURLQueryItem(name: "units",
                                             value: unitsOfMeasurement?.unitValue as Any)
        let langItem = generateURLQueryItem(name: "lang",
                                            value: language?.languageValue as Any)
        
        return [modeItem, cntItem, unitsItem, langItem].compactMap { $0 }
    }
    
    private func generateURLQueryItem(name: String, value: Any) -> URLQueryItem? {
        if NSNull.isEqual(value) {
            return nil
        } else {
            return URLQueryItem(name: name, value: "\(value)")
        }
    }
}

enum ContentType: String {
    case json
    
    var formatValue: String {
        return self.rawValue
    }
}

enum MeasurementType: String {
    case standard
    case metric
    case imperial
    
    var unitValue: String {
        return self.rawValue
    }
}

enum LanguageType: String {
    case korean = "kr"
    
    var languageValue: String {
        return self.rawValue
    }
}

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
            return "https://api.openweathermap.org/data/2.5/weather"
        case .fiveDays:
            return "https://api.openweathermap.org/data/2.5/forecast"
        }
    }
}

struct CommonWeatherAPIParameter {
    let responseFormat: ResponseFormat?
    let numberOfTimestamps: Int?
    let unitsOfMeasurement: MeasurementType?
    let language: LanguageType?
    
    func generateURLQueryItems() -> [URLQueryItem] {
        let modeItem = generateURLQueryItem(name: "mode",
                                            value: responseFormat?.formatValue)
        let cntItem = generateURLQueryItem(name: "cnt",
                                           value: numberOfTimestamps?.description)
        let unitsItem = generateURLQueryItem(name: "units",
                                             value: unitsOfMeasurement?.unitValue)
        let langItem = generateURLQueryItem(name: "lang",
                                            value: language?.languageValue)
        
        return [modeItem, cntItem, unitsItem, langItem].compactMap { $0 }
    }
    
    private func generateURLQueryItem(name: String, value: String?) -> URLQueryItem? {
        
        if let value = value {
            return URLQueryItem(name: name, value: value)
        } else {
            return nil
        }
    }
}

enum ResponseFormat: String {
    case json
    case xml
    case html
    
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
    
    var notation: String {
        switch self {
        case .standard:
            return "K"
        case .imperial:
            return "°F"
        case .metric:
            return  "°C"
        }
    }
    
    static func getMeasurementType(by preferredLanguage: String?) -> MeasurementType {
        guard let preferredLanguage = preferredLanguage else {
            return .standard
        }
        let locale = Locale(identifier: preferredLanguage)
        switch locale.languageCode {
        case "ko":
            return .metric
        case "en":
            return .imperial
        default:
            return .standard
        }
    }
}

enum LanguageType: String {
    case korean = "kr"
    
    var languageValue: String {
        return self.rawValue
    }
}

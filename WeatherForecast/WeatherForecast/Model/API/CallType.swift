//
//  CallType.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/09/28.
//

import Foundation

enum CallType {
    case cityName(cityName: String, responseFormat: ContentType?,
                  numberOfTimestamps: Int?, unitsOfMeasurement: MeasurementType?,
                  language: LanguageType?)
    case cityID(cityID: Int, responseFormat: ContentType?,
                numberOfTimestamps: Int?, unitsOfMeasurement: MeasurementType?,
                language: LanguageType?)
    case geographicCoordinates(latitude: Double, longitude: Double,
                               responseFormat: ContentType?, numberOfTimestamps: Int?,
                               unitsOfMeasurement: MeasurementType?, language: LanguageType?)
    case ZIPCode(ZIPCode: Int, responseFormat: ContentType?,
                 numberOfTimestamps: Int?, unitsOfMeasurement: MeasurementType?,
                 language: LanguageType?)
}

enum ContentType {
    case json
    
    var description: String {
        switch self {
        case .json:
            return "application/json"
        }
    }
}

enum MeasurementType: String {
    case standard
    case metric
    case imperial
    
    var unitDescription: String {
        return self.rawValue
    }
}

enum LanguageType: String {
    case korean = "kr"
    
    var languageDescription: String {
        return self.rawValue
    }
}

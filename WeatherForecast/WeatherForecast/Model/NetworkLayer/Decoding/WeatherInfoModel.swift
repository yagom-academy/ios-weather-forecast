//
//  WeatherInfoModel.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/29.
//

import Foundation

struct Parser {
    private let decoder = JSONDecoder()
    
    func decode<Model: Decodable>(_ data: Data, to model: Model.Type) throws -> Model {
        do {
            let parsedData = try decoder.decode(model, from: data)
            return parsedData
        } catch DecodingError.dataCorrupted(let context) {
            throw DecodingError.dataCorrupted(context)
        } catch DecodingError.keyNotFound(let codingKey, let context) {
            throw DecodingError.keyNotFound(codingKey, context)
        } catch DecodingError.typeMismatch(let type, let context) {
            throw DecodingError.typeMismatch(type, context)
        } catch DecodingError.valueNotFound(let value, let context) {
            throw DecodingError.valueNotFound(value, context)
        }
    }
}

struct CurrentWeather: Decodable {
    var coordination: Coordinate
    var weather: [Weather]
    var main: Temperature
    
    enum CodingKeys: String, CodingKey {
        case coordination = "coord"
        case weather, main
    }
    
    struct Weather: Decodable {
        var icon: String
    }
    
    struct Temperature: Decodable {
        var temperatureMinimum: Double
        var temperatureMaximum: Double
        
        enum CodingKeys: String, CodingKey {
            case temperatureMinimum = "temp_min"
            case temperatureMaximum = "temp_max"
        }
    }
    
    struct Coordinate: Decodable {
        var longitude: Double
        var lattitude: Double
        
        enum CodingKeys: String, CodingKey {
            case longitude = "lon"
            case lattitude = "lat"
        }
    }
}

struct FiveDaysForecast: Decodable {
    var list: [ListDetail]
    
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
}





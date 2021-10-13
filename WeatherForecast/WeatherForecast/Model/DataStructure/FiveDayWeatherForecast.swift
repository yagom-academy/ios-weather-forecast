//
//  FiveDayWeatherForecast.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/09/28.
//

import Foundation

struct FiveDayWeatherForecast: Decodable, Equatable {
    
    let statusCode: String?
    let message: Int?
    let numberOfTimeStamps: Int?
    let weatherForFiveDays: [WeatherForOneDay]?
    let city: City?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "cod"
        case message, city
        case numberOfTimeStamps = "cnt"
        case weatherForFiveDays = "list"
    }
    
    static func == (lhs: FiveDayWeatherForecast, rhs: FiveDayWeatherForecast) -> Bool {
        guard let lhsWeatherForFiveDays = lhs.weatherForFiveDays,
              let rhsWeatherForFiveDays = rhs.weatherForFiveDays,
              lhsWeatherForFiveDays.count == rhsWeatherForFiveDays.count,
              let lhsCityId = lhs.city?.id, let rhsCityId = rhs.city?.id,
              lhsCityId == rhsCityId else {
            return false
        }
        
        for index in .zero..<lhsWeatherForFiveDays.count {
            if lhsWeatherForFiveDays[index].timeOfDataCalculation != rhsWeatherForFiveDays[index].timeOfDataCalculation {
                return false
            }
        }
        return true
    }
}

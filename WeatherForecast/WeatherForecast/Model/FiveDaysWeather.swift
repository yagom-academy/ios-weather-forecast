//
//  ForecastWeather.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/09/30.
//

import Foundation
import UIKit.UIImage

struct FiveDaysWeather: Decodable {
    var list: [List]
    
    struct List: Decodable {
        let forecastTime: TimeInterval
        let forecastTimeText: String
        let main: Main
        let weather: [Weather]
        var iconImage: UIImage?
        var iconURL: String
        
        enum CodingKeys: String, CodingKey {
            case main, weather
            case forecastTime = "dt"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            main = try values.decode(Main.self,
                                 forKey: .main)
            weather = try values.decode([Weather].self,
                                      forKey: .weather)
            forecastTime = try values.decode(TimeInterval.self,
                                             forKey: .forecastTime)
            forecastTimeText = String.convertTimeInvervalForLocalizedText(forecastTime)
            
            if let iconPath = self.weather.first?.icon {
                iconURL = WeatherAPI.icon.url + iconPath
            } else {
                iconURL = ""
            }
        }
    }
    
    struct Main: Decodable {
        let temp: Double
        let tempText: String
        
        enum CodingKeys: String, CodingKey {
            case temp
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            temp = try values.decode(Double.self,
                                 forKey: .temp)
            tempText = String.convertTempature(temp)
            
        }
    }
    
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
}

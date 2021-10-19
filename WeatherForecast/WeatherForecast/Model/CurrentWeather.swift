//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/09/30.
//

import Foundation
import UIKit.UIImage

struct CurrentWeather: Decodable {
    let weather: [Weather]
    var main: Main
    var iconImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case weather, main
    }
    
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Decodable {
        var address: String?
        let temp: Double
        let tempMin: Double
        let tempMax: Double
        let tempText: String
        let tempMinText: String
        let tempMaxText: String
        
        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            temp = try values.decode(Double.self,
                                 forKey: .temp)
            tempMin = try values.decode(Double.self,
                                        forKey: .tempMin)
            tempMax = try values.decode(Double.self,
                                        forKey: .tempMax)
            
            tempText = String.convertTempature(temp)
            tempMinText = String.convertTempature(tempMin)
            tempMaxText = String.convertTempature(tempMax)
        }
    }
}

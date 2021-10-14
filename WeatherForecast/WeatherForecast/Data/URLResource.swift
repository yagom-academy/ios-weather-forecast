//
//  URLResource.swift
//  WeatherForecast
//
//  Created by  호싱잉, 잼킹 on 2021/10/08.
//

import Foundation

struct URLResource {
    let scheme = "https"
    let host = "api.openweathermap.org"
    
    enum PathType: String {
        case current = "/data/2.5/weather"
        case fiveDays = "/data/2.5/forecast"
        
        static func weatherImage(num: Int) -> String {
            if num < 10 {
                return "img/w/0\(num)d.png"
            }
            return "img/w/\(num)d.png"
        }
    }

    struct QueryParam {
        let name: String
        let value: String
    }
}


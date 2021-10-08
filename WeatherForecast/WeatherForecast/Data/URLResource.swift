//
//  URLResource.swift
//  WeatherForecast
//
//  Created by 잼킹, 호싱잉 on 2021/10/08.
//

import Foundation

struct URLResource {
    let scheme = "https"
    let host = "api.openweathermap.org"
    
    enum PathType: String {
        case current = "/data/2.5/weather"
        case fiveDays = "/data/2.5/forecast"
    }

    struct QueryParam {
        let name: String
        let value: String
    }
}


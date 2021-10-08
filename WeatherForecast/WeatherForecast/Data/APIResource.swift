//
//  APIResource.swift
//  WeatherForecast
//
//  Created by  호싱잉, 잼킹 on 2021/10/08.
//

import Foundation

enum ParamName: String {
    case lat, lon, appid, units, lang
}

enum AppID {
    static let jamkingID = "af361cc4ac7bf412119174d64ba296ff"
}

enum Units {
    static let metric = "metric"
}

enum Lang {
    static let korea = "kr"
}

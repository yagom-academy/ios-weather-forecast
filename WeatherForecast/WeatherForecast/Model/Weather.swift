//
//  Weather.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/09/28.
//

import Foundation

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

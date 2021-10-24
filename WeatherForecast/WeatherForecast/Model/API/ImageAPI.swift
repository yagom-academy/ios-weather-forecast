//
//  ImageAPI.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/10/16.
//

import Foundation

struct ImageAPI: APIable {
    var url: URL?
    
    init(imageId: String) {
        url = URL(string: "https://openweathermap.org/img/w/\(imageId).png")
    }
}

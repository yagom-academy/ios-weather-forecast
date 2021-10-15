//
//  ImageAPI.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/10/16.
//

import Foundation

struct ImageAPI: APIable {
    var requestType: RequestType = .get
    var url: URL?
    var parameter: [String : Any]?
    var contentType: ContentType?
    
    init(imageId: String) {
        url = URL(string: "https://openweathermap.org/img/w/\(imageId).png")
    }
}

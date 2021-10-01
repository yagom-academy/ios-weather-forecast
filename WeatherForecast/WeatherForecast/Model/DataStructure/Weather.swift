//
//  Weather.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/09/28.
//

import Foundation

struct Weather: Decodable {
    let conditionId: Int?
    let kind: String?
    let description: String?
    let iconId: String?
    
    enum CodingKeys: String, CodingKey {
        case conditionId = "id"
        case kind = "main"
        case description
        case iconId = "icon"
    }
}

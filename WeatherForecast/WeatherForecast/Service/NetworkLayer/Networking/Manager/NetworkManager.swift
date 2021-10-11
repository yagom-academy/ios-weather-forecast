//
//  WeatherApi.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation

final class NetworkManager {
    private let router = Router<WeatherApi>()
    private let apiKey = "9cda367698143794391817f65f81c76e"
    var openWeahterApiKey: String {
        return self.apiKey
    }
    
    func getCurrentWeatherData(weatherAPI: WeatherApi, _ session: URLSession) {
        router.request(weatherAPI, session)
    }
}

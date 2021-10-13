//
//  WeatherApi.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation

final class WeatherNetworkManager: ApiModeling {
    private let router = Router<OpenWeatherApi>()
    static let apiKey = "9cda367698143794391817f65f81c76e"
    
    func fetchOpenWeatherData(requiredApi: OpenWeatherApi, _ session: URLSession) {
        router.request(requiredApi, session)
    }
}

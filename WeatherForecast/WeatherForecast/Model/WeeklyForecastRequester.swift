//
//  WeeklyForecastRequester.swift
//  WeatherForecast
//
//  Created by kjs on 2021/10/20.
//

import Foundation

struct WeeklyForecastRequester: Requestable {
    typealias ResponseType = WeeklyWeatherForecast

    var path = "forecast"
    var latitude: Double
    var longitude: Double
    var parameters: [String: Any] {
        return [
            "lat": latitude,
            "lon": longitude
        ]
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    func fetch(
        completionHandler: @escaping (Result<WeeklyWeatherForecast, Error>) -> Void
    ) {
        let path = EndPoint.apiBaseURL + path
        guard let url = URLGenerator.work(with: path, parameters: parameters) else {
            completionHandler(.failure(NetworkError.invalidURL))
            return
        }

        NetworkManager.shared.request(with: url, completionHandler: completionHandler)
    }
}

//
//  Response.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/20.
//

import Foundation

class FindAPI {
    let appID: String = "179f9f1734b59fcdd8627cb64e9fae5d"
    static func find(_ latitude: Double, _ longitude: Double, completion: @escaping (CurrentWeather) -> Void) {
        let session = URLSession(configuration: .default)
        guard var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather?") else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: "179f9f1734b59fcdd8627cb64e9fae5d")
        ]
        guard let requestURL = urlComponents.url else {
            return
        }
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            let successRange = 200..<300
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else { return }
            guard let resultData = data else { return }
            guard let currentWeatherInfo = FindAPI.parse(resultData) else { return }
            completion(currentWeatherInfo)
        }
        dataTask.resume()
    }
    static func parse(_ data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(CurrentWeather.self, from: data)
            return response
        } catch let error {
            print("parsing error: \(error.localizedDescription)")
            return nil
        }
    }
}

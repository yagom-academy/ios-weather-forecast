//
//  Response.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/20.
//

import Foundation

class WeatherAPI {
   
    static func findCurrentWeather(_ latitude: Double, _ longitude: Double, completion: @escaping (CurrentWeather) -> Void) {
        let session = URLSession(configuration: .default)
        guard var urlComponents = URLComponents(string: App.cuurentWeather.URL) else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: App.key.text),
            URLQueryItem(name: "units", value: "metric")
        ]
        guard let requestURL = urlComponents.url else { return }
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            let successRange = 200..<300
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else { return }
            guard let resultData = data else { return }
            guard let currentWeatherInfo = WeatherAPI.parseCurrentWeather(resultData) else { return }
            completion(currentWeatherInfo)
        }
        dataTask.resume()
    }
    
    static func parseCurrentWeather(_ data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(CurrentWeather.self, from: data)
            return response
        } catch let error {
            print("parsing error: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func findFivedaysForecast(_ latitude: Double, _ longitude: Double, completion: @escaping (Forecast) -> Void) {
        let session = URLSession(configuration: .default)
        guard var urlComponents = URLComponents(string: App.fivedaysForecast.URL) else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: App.key.text),
            URLQueryItem(name: "units", value: "metric")
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
            guard let fivedaysForecastWeatherInfo = WeatherAPI.parseFivedaysForecast(resultData) else { return }
            completion(fivedaysForecastWeatherInfo)
        }
        dataTask.resume()
    }
    
    static func parseFivedaysForecast(_ data: Data) -> Forecast? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(Forecast.self, from: data)
            return response
        } catch let error {
            print("parsing error: \(error.localizedDescription)")
            return nil
        }
    }
}

//
//  WeatherForecastManager.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/19.
//

import Foundation

final class WeatherForecastManager {
    static let shared = WeatherForecastManager()
    private init() {}
    
    func loadData(lat: Double, lon: Double, api: WeatherAPI, completion: @escaping ((Result<Data?, WeatherForecastError>) -> Void))  {
        var apiURL: String?
        switch api {
        case .current:
            apiURL = Config.currentWeatherURL(lat: lat, lon: lon)
        case .forecast:
            apiURL = Config.forcastWeatherURL(lat: lat, lon: lon)
        }
        
        guard let stringURL = apiURL, let url = URL(string: stringURL) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                return completion(.failure(.failTransportData))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.failFetchData))
            }
            
            guard let mimeType = httpResponse.mimeType, mimeType == "application/json" else {
                return completion(.failure(.failMatchingMimeType))
            }
            
            guard let data = data else {
                return completion(.failure(.failGetData))
            }
            return completion(.success(data))
        }
        dataTask.resume()
    }
    
    func loadImage(imageID: String, completion: @escaping ((Result<Data?, WeatherForecastError>) -> Void)) {
        let apiURL = Config.weatherImageURL(imageID: imageID)
        guard let url = URL(string: apiURL) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                return completion(.failure(.failTransportData))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.failFetchData))
            }
            
            guard let mimeType = httpResponse.mimeType, mimeType == "image/png" else {
                return completion(.failure(.failMatchingMimeType))
            }
            
            guard let data = data else {
                return completion(.failure(.failGetData))
            }
            
            return completion(.success(data))
        }
        dataTask.resume()
    }
}

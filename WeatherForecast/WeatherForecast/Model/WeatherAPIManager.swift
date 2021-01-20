//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/19.
//

import Foundation

struct WeatherAPIManager {
    enum Information {
        case CurrentWeather
        case FiveDayForecast
        
        var apiURL: String {
            let url = "https://api.openweathermap.org/data/2.5"
            switch self {
            case .CurrentWeather:
                return "\(url)/weather?"
            case .FiveDayForecast:
                return "\(url)/forecast?"
            }
        }
    }
    
    var delegate: WeatherAPIManagerDelegate?
    private let decoder = JSONDecoder()
    private let appId = "02989ef69361857d2d2779ea712468b7"
    
    func request(information: Information, latitude: Double, logitude: Double) {
        guard let delegate = delegate else {
            return
        }
        
        guard var urlComponents = URLComponents(string: information.apiURL) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(logitude)),
            URLQueryItem(name: "appid", value: appId),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                switch information {
                case .CurrentWeather:
                    let response = try decoder.decode(CurrentWeather.self, from: data)
                    delegate.setCurrentWeather(from: response)
                case .FiveDayForecast:
                    let response = try decoder.decode(FiveDayForecast.self, from: data)
                    delegate.setFiveDayForecast(from: response)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        dataTask.resume()
    }
}

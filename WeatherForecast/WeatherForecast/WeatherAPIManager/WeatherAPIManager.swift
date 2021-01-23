//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/19.
//

import Foundation

enum WeatherAPIManagerError {
    case networkFailure(Error)
    case decodingError
}

struct WeatherAPIManager {
    enum Information {
        case currentWeather
        case fiveDayForecast
    }
    
    var delegate: WeatherAPIManagerDelegate?
    private let decoder = JSONDecoder()
    private let appId = "02989ef69361857d2d2779ea712468b7"
    private let apiURLs: [Information: String] = [.currentWeather: "https://api.openweathermap.org/data/2.5/weather?",
                                                  .fiveDayForecast: "https://api.openweathermap.org/data/2.5/forecast?"]
    
    func request(information: Information, latitude: Double, logitude: Double) {
        guard let delegate = delegate else {
            return
        }
        
        guard let apiURL = apiURLs[information],
              let urlRequest = getURLRequest(apiURL: apiURL, latitude: latitude, logitude: logitude) else {
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                switch information {
                case .currentWeather:
                    let response = try decoder.decode(CurrentWeather.self, from: data)
                    delegate.setCurrentWeather(from: response)
                case .fiveDayForecast:
                    let response = try decoder.decode(FiveDayForecast.self, from: data)
                    delegate.setFiveDayForecast(from: response)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func getQueryItems(latitude: Double, logitude: Double) -> [URLQueryItem] {
        let queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(logitude)),
            URLQueryItem(name: "appid", value: appId),
            URLQueryItem(name: "units", value: "metric")
        ]
        return queryItems
    }
    
    private func getURLRequest(apiURL: String, latitude: Double, logitude: Double) -> URLRequest? {
        guard var urlComponents = URLComponents(string: apiURL) else {
            return nil
        }
        urlComponents.queryItems = getQueryItems(latitude: latitude, logitude: logitude)
        guard let url = urlComponents.url else {
            return nil
        }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
}

//
//  WeatherManager.swift
//  WeatherForecast
//
//  Created by 김지혜 on 2021/01/22.
//

import Foundation

enum WeatherError: Error {
    case apiCallError
    
    var errorMessage: String {
        switch self {
        case .apiCallError:
            return "데이터를 가져오는데 실패했습니다."
        }
    }
}

struct WeatherManager {
    private enum ServiceAPI {
        case currentWeather(Double, Double)
        case fiveDaysForecastWeathers(Double, Double)
        case weatherIconImage(String)
        
        var apiKey: String {
            switch self {
            case .currentWeather, .fiveDaysForecastWeathers, .weatherIconImage:
                return "1c3be24879e17dcc0bd319a5d7afe693"
            }
        }
        
        var urlString: String {
            switch self {
            case .currentWeather:
                return "https://api.openweathermap.org/data/2.5/weather"
            case .fiveDaysForecastWeathers:
                return "https://api.openweathermap.org/data/2.5/forecast"
            case .weatherIconImage(let id):
                return "https://openweathermap.org/img/w/\(id)"
            }
        }
        
        var query: String {
            switch self {
            case let .currentWeather(latitude, longitude),
                 let .fiveDaysForecastWeathers(latitude, longitude):
                return "lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
            default:
                return ""
            }
        }
        
        var fullUrl: URL? {
            switch self {
            case .currentWeather, .fiveDaysForecastWeathers:
                var urlComponents = URLComponents(string: urlString)
                urlComponents?.query = query
                return urlComponents?.url
            case .weatherIconImage:
                return URL(string: urlString)
            }
        }
    }
    
    static let shared = WeatherManager()
    private let jsonDecoder = JSONDecoder()
    private init() {}
    
    func getCurrentWeather(of coordinate: Coordinate, completion: @escaping (Weather) -> Void) {
        guard let url = ServiceAPI.currentWeather(coordinate.latitude, coordinate.longitude).fullUrl else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let response: Weather = try jsonDecoder.decode(Weather.self, from: data)
                    completion(response)
                } catch let error {
                    print(WeatherError.apiCallError.errorMessage)
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getFivedaysForecastWeathers(of coordinate: Coordinate, completion: @escaping ([Weather]) -> Void) {
        guard let url = ServiceAPI.fiveDaysForecastWeathers(coordinate.latitude, coordinate.longitude).fullUrl else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let response: FivedaysForecastWeathers = try jsonDecoder.decode(FivedaysForecastWeathers.self, from: data)
                    completion(response.weathers)
                } catch let error {
                    print(WeatherError.apiCallError.errorMessage)
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getWeatherImage(id: String, completion: @escaping (Data) -> Void) {
        guard let url = ServiceAPI.weatherIconImage(id).fullUrl else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                print(WeatherError.apiCallError.errorMessage)
                return
            }
            completion(data)
        }
    }
}

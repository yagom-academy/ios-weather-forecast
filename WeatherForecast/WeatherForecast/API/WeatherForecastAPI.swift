//
//  WeatherForecastAPI.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/24.
//

import Foundation
import CoreLocation

class WeatherForecastAPI {
    enum APIError: Error {
        case invalidURL
        case requestFailed
        case noData
        case invalidData
    }
    
    static let shared: WeatherForecastAPI = WeatherForecastAPI()
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast?"
    private let apiKey = "d581ffc8458e8085899bfe16c04fe7da"
    private var urlSession = URLSession(configuration: .default)
    
    private init() {}
    
    func getData(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (Result<WeatherForecast, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=metric&appid=\(apiKey)") else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let dataTask = urlSession.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.failure(.requestFailed))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            do {
                let decodedData: WeatherForecast = try JSONDecoder().decode(WeatherForecast.self, from: data)
                completionHandler(.success(decodedData))
            } catch {
                completionHandler(.failure(.invalidData))
            }
        }
        dataTask.resume()
    }
}

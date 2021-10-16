//
//  WeatherNetworkManager.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/15.
//

import Foundation

final class WeatherNetworkManager: NetworkManager {
    func weatherIconImageDataTask(url: URL, completion: @escaping (Data) -> Void) {
        dataTask(url: url) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(_):
                break
            }
        }
    }
    
    func fetchingWeatherData<T: Decodable>(api: WeatherAPI,
                                           type: T.Type,
                                           coordinate: (lat: Double, lon: Double),
                                           completion: @escaping (T?, Error?) -> Void) {
        
        let queryItems = [CoordinatesQuery.lat: String(coordinate.lat),
                          CoordinatesQuery.lon: String(coordinate.lon),
                          CoordinatesQuery.appid: "e6f23abdc0e7e9080761a3cfbbdafc90",
                          CoordinatesQuery.units: "metric"
        ]
        
        guard let url = URL.createURL(API: api, queryItems: queryItems) else { return }
        
        dataTask(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(type, from: data)
                    completion(decodedData, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

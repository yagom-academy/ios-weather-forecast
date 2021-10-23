//
//  WeatherNetworkManager.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/15.
//

import Foundation
import UIKit.UIImage

final class WeatherNetworkManager: NetworkManager {
    func weatherIconImageDataTask(url: URL, completion: @escaping (UIImage) -> Void) {
        
        if let cacheImage = WeatherImageChche.shared.getObject(forKey: NSString(string: url.absoluteString)) {
            completion(cacheImage)
            return
        }
        
        dataTask(url: url) { result in
            switch result {
            case .success(let data):
                UIImage(data: data).flatMap {
                    WeatherImageChche.shared.setObject(forKey: NSString(string: url.absoluteString),
                                                       object: $0)
                    completion($0)
                }
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

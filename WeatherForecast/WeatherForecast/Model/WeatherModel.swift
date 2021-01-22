//
//  Weather.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/21.
//

import Foundation

class WeatherModel {
    static let shared = WeatherModel()
    private init() {}
    
    private(set) var item: CurrentWeather? = nil
    
    func fetchData(with coordinate: Coordinate, _ callback: @escaping (_ item: CurrentWeather?) -> Void) {
        let urlString = NetworkConfig.makeWeatherUrlString(type: .current, coordinate: coordinate)
        guard let url = URL(string: urlString) else {
             return
        }
        WeatherNetwork.loadData(from: url, with: CurrentWeather.self) { result in
            switch result {
            case .failure:
                callback(nil)
            case .success(let data):
                self.item = data
                callback(data)
            }
        }
    }
}

//
//  ForecastModel.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/21.
//

import Foundation

class ForecastModel {
    static let shared = ForecastModel()
    private init() {}
    
    private(set) var item: FiveDaysForecast? = nil
    
    func fetchData(with coordinate: Coordinate, _ callback: @escaping (_ item: FiveDaysForecast?) -> Void) {
        let urlString = NetworkConfig.makeWeatherUrlString(type: .fiveDaysForecast, coordinate: coordinate)
        guard let url = URL(string: urlString) else {
             return
        }
        WeatherNetwork.loadData(from: url, with: FiveDaysForecast.self) { result in
            switch result {
            case .failure:
                callback(nil)
            case .success(let data):
                callback(data)
            }
        }
    }
}

//
//  HTTPMethod.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/10/01.
//

import Foundation

class HTTPMethod {
    let networkManager = NetworkManager()
    let parsingManager = ParsingManager()
    
    func getCurrentWeather(url: URL) {
        networkManager.request(url: url) { result in
            switch result {
            case .success(let data):
                let jsonData = self.parsingManager.parse(data, to: CurrentWeather.self)
                switch jsonData {
                case .success(let currentWeather):
                    print(currentWeather)
                case .failure(let error):
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getFiveDayForecast(url: URL) {
        networkManager.request(url: url) { result in
            switch result {
            case .success(let data):
                let jsonData = self.parsingManager.parse(data, to: FiveDayForecast.self)
                switch jsonData {
                case .success(let fiveDayForecast):
                    print(fiveDayForecast)
                case .failure(let error):
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

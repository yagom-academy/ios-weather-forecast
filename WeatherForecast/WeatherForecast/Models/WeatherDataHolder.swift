//
//  DataHolder.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/20.
//

import Foundation

final class WeatherDataHolder {
    static let shared = WeatherDataHolder()
    
    var forcast: FiveDaysForecastData?
    var current: CurrentWeather?
    
    private init() { }
    
    func generate(_ path: String, _ data: Data) {
        guard let path = PathOptions.Paths(rawValue: path) else {
            return
        }
        
        switch path {
        case .forecast :
            do {
                let decodedData = try  Parser().decode(data, to: FiveDaysForecastData.self)
                self.forcast = decodedData
                NotificationCenter.default.post(name: .reloadTableView, object: nil)

            } catch {
                print(error)
            }
        case .current :
            do {
                let decodedData = try Parser().decode(data, to: CurrentWeather.self)
                self.current = decodedData
            } catch {
                print(error)
            }
            
        default:
            break
        }
        
        NotificationCenter.default.post(name: .stopRefresh, object: nil)
    }
}

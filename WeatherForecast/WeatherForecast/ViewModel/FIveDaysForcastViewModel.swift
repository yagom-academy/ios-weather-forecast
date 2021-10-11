//
//  WeatherInfoList.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import Foundation
struct FiveDaysForecast: Decodable {
    var lists: [FiveDaysForcastList]
}

struct FiveDaysForcastList: Decodable {
    var date: Int
    var main: Temperature
    var weather: [WeatherDetail]
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main, weather
    }
    
    struct Temperature: Decodable {
        var temperature: Double
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
        }
    }
    
    struct WeatherDetail: Decodable {
        var icon: String
    }
}

// MARK: - Model for tableView
struct FiveDaysForecastViewModel {
    let lists: [FiveDaysForcastList]
    
    func numberOfRowsInSection(_ sections: Int) -> Int {
        return self.lists.count
    }
    
    func list(at index: Int) -> FiveDaysForcastListViewModel {
        let weatherInfo = self.lists[index]
        return FiveDaysForcastListViewModel(weatherInfo)
    }
}

// MARK: - Model for tableView's Cell
struct FiveDaysForcastListViewModel {
    private let weatherDetail: FiveDaysForcastList
    
    init(_ weatherDetail: FiveDaysForcastList) {
        self.weatherDetail = weatherDetail
    }
    
    var date: Int {
        return self.weatherDetail.date
    }
    
    var temperature: Double {
        return self.weatherDetail.main.temperature
    }
    
    var icon: String {
        return self.weatherDetail.weather.first?.icon ?? "iconPlaceHolder"
    }
}


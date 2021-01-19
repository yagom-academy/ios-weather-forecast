//
//  WeatherModelDelegate.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/19.
//

import Foundation

protocol WeatherModelDelegate {
    func setCurrentWeather(from response: CurrentWeatherResponse)
    func setFiveDayForecast(from response: FiveDayForecastResponse)
}

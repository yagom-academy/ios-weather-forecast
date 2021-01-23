//
//  WeatherModelDelegate.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/19.
//

import Foundation

protocol WeatherAPIManagerDelegate {
    func setCurrentWeather(from response: CurrentWeather)
    func setFiveDayForecast(from response: FiveDayForecast)
    func handleAPIError(_ apiError: WeatherAPIManagerError)
}

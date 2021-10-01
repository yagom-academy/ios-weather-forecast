//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherForecastAPI.getWeather(endPoint: .daily, params: .coordinate(coord: Coordinate(longitude: 1.0, latitude: 2.0)))
            .urlComponents
        WeatherForecastAPI.getWeather(endPoint: .weekly, params: .coordinate(coord: Coordinate(longitude: 1.0, latitude: 2.0)))
            .urlComponents
    }


}


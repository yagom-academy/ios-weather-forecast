//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let decoder = Parser()

    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherForecastAPI.getWeather(endPoint: .daily, params: .coordinate(coord: Coordinate(longitude: 1.0, latitude: 2.0)))
            .urlComponents
        WeatherForecastAPI.getWeather(endPoint: .weekly, params: .coordinate(coord: Coordinate(longitude: 1.0, latitude: 2.0)))
            .urlComponents

        if let path = Bundle.main.path(forResource: "sampleOfCurrent", ofType: "json") {
            let jsonData = try? String(contentsOfFile: path).data(using: .utf8)
            jsonData.flatMap {
                do {
                    let result = try decoder.decode($0, to: TodayWeatherInfo.self)
                    print(result)
                } catch {
                    print("?")
                }
            }
        }
    }

}


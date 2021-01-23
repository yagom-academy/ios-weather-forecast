//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let forecastSystem = ForecastingSystem()
        
        forecastSystem.announceCurrentWeather { (result) in
            switch result {
            case .success(let forecastingInformation):
                print(forecastingInformation)
            case .failure(let error):
                print(error)
            }
        }
        
        forecastSystem.announceFiveDaysForecasting { (result) in
            switch result {
            case .success(let forecastingInformation):
                print(forecastingInformation)
            case .failure(let error):
                print(error)
            }
        }
    }
}

//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let test = ForecastingSystem()
        test.searchForCurrentWeather()
        test.searchForFiveDaysForecasting()
    }


}


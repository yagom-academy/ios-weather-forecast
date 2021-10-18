//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainWeatherViewController: UIViewController {
    
    var currentWeatherViewModel = CurrentWeatherViewModel()
    var fiveDayWeatherViewModel = FiveDayWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWeatherViewModel.reload()
        fiveDayWeatherViewModel.reload()
    }
}

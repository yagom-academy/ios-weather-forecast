//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private let weatherDataViewModel: WeatherDataViewModel
        
    init(weatherDataViewModel: WeatherDataViewModel) {
        self.weatherDataViewModel = weatherDataViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImageView = UIImageView(image: UIImage(named: "NightStreet"))
        backgroundImageView.contentMode = .scaleAspectFill
        
        weatherDataViewModel.setUpWeatherData { address, currentData, fivedayData in
            print(" --> 주소 : \(address)")
            print(" --> 현재 : \(currentData)")
            print(" --> 5일 : \(fivedayData)")
        }
    }
}

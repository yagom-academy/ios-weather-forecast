//
//  WeatherListViewController.swift
//  WeatherForecast
//
//  Created by 김지혜 on 2021/01/22.
//

import UIKit

class WeatherListViewController: UIViewController {
    private var fivedaysForecastWeathers: [Weather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

extension WeatherListViewController {
    private func setUp() {
        guard let coordinate = LocationManager.shared.locationCoordinate else { return }
        LocationManager.shared.getLocalizationString(in: "Ko-kr") { (locationString) in
            // 화면에 세팅
        }
        WeatherManager.shared.getCurrentWeather(of: coordinate) { [weak self] (weather) in
            DispatchQueue.main.async {
                self?.setCurrentWeather(weather)
            }
        }
        
        WeatherManager.shared.getFivedaysForecastWeathers(of: coordinate) {
            self.fivedaysForecastWeathers = $0
        }
    }
    
    private func setCurrentWeather(_ weather: Weather) {
        // 화면에 current Weather 값 세팅
    }
}

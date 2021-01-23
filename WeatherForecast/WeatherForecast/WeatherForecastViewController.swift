//
//  WeatherForecast - WeatherForecastViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherForecastViewController: UIViewController {
    
    private let locationManager = WeatherLocationManager()
    private var weatherAPIManager = WeatherAPIManager()
    private var currentLocation: CLLocation? {
        didSet {
            requestWeatherInformation()
        }
    }
    private var currentAddress: String? {
        didSet {
            // TODO: 주소 레이블 초기화
        }
    }
    private var currentWeather: CurrentWeather? {
        didSet {
            // TODO: 현재 날씨 셀 내용 초기화
        }
    }
    private var fiveDayForecast: FiveDayForecast? {
        didSet {
            // TODO: 5일 날씨 예보 셀 내용 초기화
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherAPIManager.delegate = self
        locationManager.delegate = self
        locationManager.requestAuthorization()
    }

}

extension WeatherForecastViewController: WeatherAPIManagerDelegate {
    func setCurrentWeather(from response: CurrentWeather) {
        self.currentWeather = response
    }
    
    func setFiveDayForecast(from response: FiveDayForecast) {
        self.fiveDayForecast = response
    }
}

extension WeatherForecastViewController: WeatherLocationManagerDelegate {
    func setAddress(_ address: String) {
        self.currentAddress = address
    }
    
    func setLocation(_ location: CLLocation) {
        self.currentLocation = location
    }
}

extension WeatherForecastViewController {
    func requestWeatherInformation() {
        guard let currentLocation = self.currentLocation else {
            return
        }
        self.weatherAPIManager.request(information: .currentWeather, latitude: currentLocation.coordinate.latitude, logitude: currentLocation.coordinate.longitude)
        self.weatherAPIManager.request(information: .fiveDayForecast, latitude: currentLocation.coordinate.latitude, logitude: currentLocation.coordinate.longitude)
    }
}

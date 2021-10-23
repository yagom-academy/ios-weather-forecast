//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/12.
//

import CoreLocation

protocol WeatherServiceDelegate: AnyObject {
    func didUpdatedWeatherDatas(current: CurrentWeather?, fiveDays: FiveDaysWeather?)
}

final class WeatherService {
    static let shared = WeatherService()
    
    weak var delegate: WeatherServiceDelegate?
    
    private var locationManager = LocationManager()
    private var currentData: CurrentWeather?
    private var fiveDaysData: FiveDaysWeather? {
        didSet {
            delegate?.didUpdatedWeatherDatas(current: self.currentData,
                                             fiveDays: self.fiveDaysData)
        }
    }
    
    private init() {
        self.locationManager.delegate = self
    }
    
}

// MARK: - Method
extension WeatherService {
    
    func refreshData() {
        locationManager.requestLocation()
    }
}

// MARK: - LocationManagerDelegate
extension WeatherService: LocationManagerDelegate {
    func didUpdateLocation(_ currnet: CurrentWeather?, _ fiveDays: FiveDaysWeather?) {
        self.currentData = currnet
        self.fiveDaysData = fiveDays
    }
}

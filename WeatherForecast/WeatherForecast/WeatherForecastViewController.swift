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
        locationManager.requestWhenInUseAuthorization()
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

extension WeatherForecastViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            guard let currentLocation = locationManager.location else {
                return
            }
            self.currentLocation = currentLocation
            requestAddress(of: currentLocation) { (currentAddress) in
                self.currentAddress = currentAddress
            }
            weatherAPIManager.request(information: .currentWeather, latitude: currentLocation.coordinate.latitude, logitude: currentLocation.coordinate.longitude)
            weatherAPIManager.request(information: .fiveDayForecast, latitude: currentLocation.coordinate.latitude, logitude: currentLocation.coordinate.longitude)
        }
    }
    
    func requestAddress(of location: CLLocation, _ completionHandler: @escaping (String) -> Void ) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                let currentAddress = self.address(from: placemark)
                completionHandler(currentAddress)
            }
        }
    }
    
    func address(from placemark: CLPlacemark) -> String {
        var address = ""
        if let state = placemark.administrativeArea {
            address += state
        }
        if let city = placemark.locality {
            if address != "" {
                address += " "
            }
            address += city
        }
        if let district = placemark.subLocality {
            if address != "" {
                address += " "
            }
            address += district
        }
        return address
    }
}


//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private var currentWeather: CurrentWeather? = nil
    private var fiveDaysForecast: Forecast? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
    }
    
    private func setUpData(coordinate: Coordinate) {
        
    }
    
    private func makeCurrentWeatherData(with coordinate: Coordinate) {
        let session = URLSession(configuration: .default)
        let currentWeatherURLString = NetworkConfig.makeWeatherUrlString(type: .current, latitude: coordinate.latitude, longitude: coordinate.latitude)
        guard let currentWeatherUrl = URL(string: currentWeatherURLString) else {
            return showError(WeatherForcastError.convertURL, handler: nil)
        }
    }
}

// MARK: - CLLocationManager Delegate
extension ViewController: CLLocationManagerDelegate {
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission()
    }
    
    private func checkLocationPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            searchCoordinate()
        case .denied:
            deniedLocationPermission()
        default:
            return
        }
    }
    
    // MARK: - handling denied location permission
    private func deniedLocationPermission() {
        let alertController = UIAlertController(title: nil, message: "위치 정보를 허용해야 일기예보를 볼 수 있습니다.\n설정 화면으로 이동할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "이동", style: .default) { _ in
            self.openSettings()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        } else {
            self.showError(WeatherForcastError.openSettings, handler: nil)
        }
    }
    
    // MARK: - tracking user location
    private func searchCoordinate() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locationManager.location?.coordinate else {
            return self.showError(WeatherForcastError.getCoordinate, handler: nil)
        }
        setUpData(coordinate: Coordinate(latitude: coordinate.latitude, longitudh: coordinate.longitude))
    }
    
    // MARK: - handling error in CLLocationManager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        return self.showError(error, handler: nil)
    }
}

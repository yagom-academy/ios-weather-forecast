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
        makeCurrentWeatherData(with: coordinate)
        makeFiveDaysForecast(with: coordinate)
    }
    
    private func makeCurrentWeatherData(with coordinate: Coordinate) {
        let session = URLSession(configuration: .default)
        let currentWeatherURLString = NetworkConfig.makeWeatherUrlString(type: .current, coordinate: coordinate)
        guard let currentWeatherUrl = URL(string: currentWeatherURLString) else {
            let errorAlert = self.makeErrorAlert(WeatherForcastError.convertURL, handler: nil)
            return showError(errorAlert)
        }
        let dataTask = session.dataTask(with: currentWeatherUrl) { data, response, error in
            guard let responseData = data else {
                let errorAlert = self.makeErrorAlert(WeatherForcastError.getData, handler: nil)
                return self.showError(errorAlert)
            }
            do {
                self.currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: responseData)
            } catch {
                let errorAlert = self.makeErrorAlert(WeatherForcastError.convertWeatherData, handler: nil)
                return self.showError(errorAlert)
            }
        }
        dataTask.resume()
    }
    
    private func makeFiveDaysForecast(with coordinate: Coordinate) {
        let session = URLSession(configuration: .default)
        let fiveDaysForecastURLString = NetworkConfig.makeWeatherUrlString(type: .fiveDaysForecast, coordinate: coordinate)
        guard let fiveDaysForecastUrl = URL(string: fiveDaysForecastURLString) else {
            let errorAlert = self.makeErrorAlert(WeatherForcastError.convertURL, handler: nil)
            return showError(errorAlert)
        }
        let dataTask = session.dataTask(with: fiveDaysForecastUrl) { data, response, error in
            guard let responseData = data else {
                let errorAlert = self.makeErrorAlert(WeatherForcastError.getData, handler: nil)
                return self.showError(errorAlert)
            }
            do {
                self.fiveDaysForecast = try JSONDecoder().decode(Forecast.self, from: responseData)
            } catch {
                let errorAlert = self.makeErrorAlert(WeatherForcastError.convertWeatherData, handler: nil)
                return self.showError(errorAlert)
            }
        }
        dataTask.resume()
    }
    
    private func showError(_ with: UIAlertController) {
        self.present(with, animated: true, completion: nil)
    }
}

extension ViewController: CLLocationManagerDelegate {
    // MARK: - setUp LocationManager & checkPermission
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
            let errorAlert = self.makeErrorAlert(WeatherForcastError.openSettings, handler: nil)
            return showError(errorAlert)
        }
    }
    
    // MARK: - tracking user location
    private func searchCoordinate() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locationManager.location?.coordinate else {
            let errorAlert = self.makeErrorAlert(WeatherForcastError.getCoordinate, handler: nil)
            return showError(errorAlert)
        }
        setUpData(coordinate: Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
    
    // MARK: - handling error in CLLocationManager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let errorAlert = self.makeErrorAlert(error, handler: nil)
        return showError(errorAlert)
    }
}

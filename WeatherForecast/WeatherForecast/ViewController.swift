//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
    }
    
    private func setUpLocationManager() {
        appDelegate?.locationManager.delegate = self
        appDelegate?.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocationCoordinate = locations.last?.coordinate else {
            return
        }
        appDelegate?.locationManager.stopUpdatingLocation()
        let lat = CLLocationDegrees(CGFloat(currentLocationCoordinate.latitude))
        let lon = CLLocationDegrees(CGFloat(currentLocationCoordinate.longitude))
        
        WeatherForecastManager.shared.loadData(lat: lat, lon: lon, api: WeatherAPI.forecast) { [self] result in
            switch result {
            case .success(let data):
                guard let forecastData = data else {
                    return errorHandling(error: .failGetData)
                }
                do {
                    let forecastList: ForecastList = try JSONDecoder().decode(ForecastList.self, from: forecastData)
                    print(forecastList)
                } catch {
                    errorHandling(error: .failDecode)
                }
            case .failure(let error):
                errorHandling(error: error)
            }
        }
        
        WeatherForecastManager.shared.loadData(lat: lat, lon: lon, api: WeatherAPI.current) { [self] result in
            switch result {
            case .success(let data):
                guard let currentData = data else {
                    return errorHandling(error: .failGetData)
                }
                do {
                    let currentWeather: CurrentWeather = try JSONDecoder().decode(CurrentWeather.self, from: currentData)
                    print(currentWeather)
                } catch {
                    errorHandling(error: .failDecode)
                }
            case .failure(let error):
                errorHandling(error: error)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(with: .failGetCurrentLocation)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            appDelegate?.locationManager.startUpdatingLocation()
        case .denied:
            showAuthorizationAlert(with: .failGetAuthorization)
        default:
            return
        }
    }
}


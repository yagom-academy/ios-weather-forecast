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
        appDelegate?.locationManager.startUpdatingLocation()
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
        
        WeatherForecastManager.shared.loadData(lat: lat, lon: lon, api: WeatherAPI.forecast) { result in
            switch result {
            case .success(let data):
                guard let forecastData = data else {
                    return self.errorHandling(error: .failGetData)
                }
                do {
                    let forecastList: ForecastList = try JSONDecoder().decode(ForecastList.self, from: forecastData)
                    print(forecastList)
                } catch {
                    self.errorHandling(error: .failDecode)
                }
            case .failure(let error):
                self.errorHandling(error: error)
            }
        }
        
        WeatherForecastManager.shared.loadData(lat: lat, lon: lon, api: WeatherAPI.current) { result in
            switch result {
            case .success(let data):
                guard let currentData = data else {
                    return self.errorHandling(error: .failGetData)
                }
                do {
                    let currentWeather: CurrentWeather = try JSONDecoder().decode(CurrentWeather.self, from: currentData)
                    print(currentWeather)
                } catch {
                    self.errorHandling(error: .failDecode)
                }
            case .failure(let error):
                self.errorHandling(error: error)
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            showAlert(with: WeatherForecastError.failGetCurrentLocation)
        }
    }
}

extension ViewController {
    private func showAlert(with error: WeatherForecastError) {
        let alert = UIAlertController(title: "오류 발생", message: "\(String(describing: error.localizedDescription)) 앱을 다시 실행시켜주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func errorHandling(error: WeatherForecastError) {
        switch error {
        case .failGetCurrentLocation:
            DispatchQueue.main.async {
                self.showAlert(with: .failGetCurrentLocation)
            }
        case .failFetchData:
            DispatchQueue.main.async {
                self.showAlert(with: .failFetchData)
            }
        case .failMatchingMimeType:
            DispatchQueue.main.async {
                self.showAlert(with: .failMatchingMimeType)
            }
        case .failTransportData:
            DispatchQueue.main.async {
                self.showAlert(with: .failTransportData)
            }
        case .failGetData:
            DispatchQueue.main.async {
                self.showAlert(with: .failGetData)
            }
        case .failDecode:
            DispatchQueue.main.async {
                self.showAlert(with: .failDecode)
            }
        }
    }
}

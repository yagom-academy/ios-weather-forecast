//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    private var currentCoordinate: Coordinate?
    private var currentWeather: TodayWeatherInfo?
    private var weatherForecast: WeeklyWeatherForecast?
    private var address: CLPlacemark?
    
    private let locationManager = WeatherLocationManager()
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .restricted, .denied:
            showAlert(title: "위치 서비스 제공이 불가능합니다.",
                      message: "어플리케이션 설정에서 위치 권한을 허용해주세요.")
        default:
            showAlert(title: "위치 서비스 제공이 불가능합니다.",
                      message: "개발자에게 신고해주세요.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last
        else { return }
        currentCoordinate = Coordinate(longitude: location.coordinate.longitude,
                                           latitude: location.coordinate.latitude)
        
        convertToAddress(with: location) { [weak self] placemark in
            self?.address = placemark
            #if DEBUG
            print(placemark)
            #endif
        }
    
        currentCoordinate.flatMap {
            networkManager.request(
                with: TodayWeatherInfo.self,
                parameters: $0.parameters
            ) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.currentWeather = model
                    #if DEBUG
                    print(model)
                    #endif
                case .failure(let error):
                    print(error)
                }
            }
            
            networkManager.request(
                with: WeeklyWeatherForecast.self,
                parameters: $0.parameters
            ) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.weatherForecast = model
                    #if DEBUG
                    print(model)
                    #endif
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
}

extension MainViewController {
    func convertToAddress(with location: CLLocation,
                          completion: @escaping (CLPlacemark) -> Void) {
        CLGeocoder().reverseGeocodeLocation(
            location,
            preferredLocale: Locale(identifier: "ko_KR")
        ) { (placemarks, error) in
            if error != nil {
                return
            }
            guard let placemark = placemarks?.first
            else { return }
            completion(placemark)
        }
    }
}

extension MainViewController {
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

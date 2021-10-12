//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    private let locationManager = CLLocationManager(desiredAccuracy: kCLLocationAccuracyThreeKilometers)
    private var currentLocation: CLLocation? {
        willSet {
            guard let newLocation = newValue else {
                return
            }
            showAddressInfomation(newLocation)
            let currentWeatherAPI = WeatherAPI.current(.geographic(newLocation.coordinate))
            fetchWeatherData(of: currentWeatherAPI)
            let fivedayWeatherAPI = WeatherAPI.fiveday(.geographic(newLocation.coordinate))
            fetchWeatherData(of: fivedayWeatherAPI)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
}

// MARK: - 주소 불러오기
extension MainViewController {
    private func showAddressInfomation(_ location: CLLocation) {
        let koreaLocale = Locale(identifier: "ko-kr")
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: koreaLocale) { placemarks, error in
            guard error == nil else {
                NSLog("\(#function) - \(String(describing: error?.localizedDescription))")
                return
            }
            guard let placeMark = placemarks?.last else {
                NSLog("\(#function) - 지역 정보 없음")
                return
            }

            guard let administrativeArea = placeMark.administrativeArea,
                  let thoroughfare = placeMark.thoroughfare else {
                NSLog("\(#function) - 주소 정보 없음")
                return
            }
            
            print("--> 주소 : \(administrativeArea) \(thoroughfare)")
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("\(#function) - didChangeAuthorization")
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("restricted, denied")
        default:
            print("default")
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations.count)
        guard currentLocation == nil else {
            return
        }
        print("\(#function) - didUpdateLocation")
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog(error.localizedDescription)
        locationManager.requestLocation()
    }
}

// MARK: - 날씨 정보 불러오기
extension MainViewController {
    func fetchWeatherData(of api: WeatherAPI) {
        guard let url = api.makeURL() else {
            NSLog("\(#function) - URL 생성 실패")
            return
        }
        
        let networkManager = WeatherNetworkManager(session: URLSession(configuration: .default))
        networkManager.requestData(with: url) { result in
            switch result {
            case .success(let data):
                self.decodeJSON(data, of: api)
            case .failure(let error):
                NSLog("\(#function) - \(error.localizedDescription)")
            }
        }
    }
    
    func decodeJSON(_ data: Data, of type: WeatherAPI) {
        let decoder = JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase)
        do {
            switch type {
            case .current(_):
                let instance: CurrentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
                print(instance)
            case .fiveday(_):
                let instance: FiveDayWeatherData = try decoder.decode(FiveDayWeatherData.self, from: data)
                print(instance)
            }
        } catch {
            NSLog("\(#function) - \(error.localizedDescription)")
        }
    }
}

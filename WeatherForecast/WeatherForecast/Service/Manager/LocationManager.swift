//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by yun on 2021/10/05.
//

import Foundation
import CoreLocation.CLLocationManager

class LocationManager: CLLocationManager {
    func askUserLocation() {
        self.requestWhenInUseAuthorization()
    }
    
    override init() {
        super.init()
        self.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
}

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let latitude = locations.last?.coordinate.latitude,
              let longitude = locations.last?.coordinate.longitude else {
            return
        }
        
        let location: Location = (latitude, longitude)
        let sessionDelegate = OpenWeatherSessionDelegate()
        let networkManager = WeatherNetworkManager()
        
        networkManager.fetchOpenWeatherData(latitudeAndLongitude: location,
                                            requestPurpose: .currentWeather,
                                            sessionDelegate.session)
        
        networkManager.fetchOpenWeatherData(latitudeAndLongitude: location,
                                            requestPurpose: .forecast,
                                            sessionDelegate.session)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        if let error = error as? CLError {
            switch error.code {
            case .locationUnknown:
                break
            default:
                print(error.localizedDescription)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            //뷰컨에서 알림을 띄우도록 해야함...
            
            
//            showAlert(title: "❌",
//                      message: "날씨 정보를 사용 할 수 없습니다.")
            break
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            manager.requestLocation()
            break
        @unknown default: break
//            showAlert(title: "🌟",
//                      message: "애플이 새로운 정보를 추가했군요! 확인 해 봅시다😄")
        }
    }
}

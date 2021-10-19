//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by yun on 2021/10/05.
//

import Foundation
import CoreLocation.CLLocationManager

class LocationManager: CLLocationManager {
    var userState = UserState.able
    
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

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .restricted, .denied:
                toggleUserState(manager, .disable)
                break
            case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
                toggleUserState(manager, .able)
                manager.requestLocation()
                break
            @unknown default: break
            }
        }
    }
    
    private func toggleUserState(_ manager: CLLocationManager, _ state: UserState) {
        guard let locationManager = manager as? LocationManager else {
            print("매니저가 locaionManager가 아니래유")
            return
        }
       
        locationManager.userState = state
    }
}


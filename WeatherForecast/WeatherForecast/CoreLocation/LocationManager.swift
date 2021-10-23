//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/07.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ currnet: CurrentWeather?, _ fiveDays: FiveDaysWeather?)
}

enum LocationManagerError: Error {
    case emptyPlacemark
    case invalidLocation
}

final class LocationManager: NSObject {
    private var manager: CLLocationManager?
    private var currentLocation: CLLocation?
    
    weak var delegate: LocationManagerDelegate?
    
    init(manager: CLLocationManager = CLLocationManager()) {
        super.init()
        self.manager = manager
        self.manager?.delegate = self
        self.manager?.desiredAccuracy = kCLLocationAccuracyBest
    }
}

// MARK: - Method
extension LocationManager {
    func requestLocation() {
        manager?.requestLocation()
    }
}

// MARK: - Private Method
extension LocationManager {
    private func getCurrentAddress(completion: @escaping (String) -> Void) {
        guard let currentLocation = currentLocation,
              let preferredLanguage = Locale.preferredLanguages.first else {
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation,
                                            preferredLocale: Locale(identifier: preferredLanguage)) { placemark, error in
            guard let placemark = placemark?.last,
                  let country = placemark.name,
                  let locality = placemark.locality,
                  error == nil else {
                return
            }
            completion(locality + " " + country)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            print("권한없음")
        default:
            print("알수없음")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.currentLocation = location
        let networkManager = WeatherNetworkManager()
        var currentWeather: CurrentWeather?
        var fiveDaysWeather: FiveDaysWeather?
        let weatherTaskGroup = DispatchGroup()
        
        DispatchQueue.global().async(group: weatherTaskGroup) {
            weatherTaskGroup.enter()
            networkManager.fetchingWeatherData(api: WeatherAPI.current,
                                               type: CurrentWeather.self,
                                               coordinate: (lat: location.coordinate.latitude,
                                                            lon: location.coordinate.longitude)) { [weak self] weather, error in
                
                guard let weather = weather,
                      let icon = weather.weather.first?.icon,
                      let iconURL = URL(string: WeatherAPI.icon.url + icon),
                      error == nil else {
                    return
                }
                
                networkManager.weatherIconImageDataTask(url: iconURL) { image in
                    currentWeather = weather
                    currentWeather?.iconImage = image
                    weatherTaskGroup.leave()
                }
                
                weatherTaskGroup.enter()
                self?.getCurrentAddress {
                    currentWeather?.main.address = $0
                    weatherTaskGroup.leave()
                }
            }
            
            weatherTaskGroup.enter()
            networkManager.fetchingWeatherData(api: WeatherAPI.forecast,
                                               type: FiveDaysWeather.self,
                                               coordinate: (lat: location.coordinate.latitude,
                                                            lon: location.coordinate.longitude)) { forecastWeather, error in
                
                guard let forecastWeather = forecastWeather,
                      error == nil else {
                    return
                }
                
                fiveDaysWeather = forecastWeather
                weatherTaskGroup.leave()
            }
        }
        
        weatherTaskGroup.notify(queue: DispatchQueue.global()) { [weak self] in
            self?.delegate?.didUpdateLocation(currentWeather, fiveDaysWeather)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}

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
    
    func getCoordinate() -> CLLocationCoordinate2D? {
        return currentLocation?.coordinate
    }
    
    func requestLocation() {
        manager?.requestLocation()
    }
    
    func getAddress(completion: @escaping (Result<CLPlacemark, Error>) -> Void) {
        guard let currentLocation = currentLocation else {
            return
        }
        
        guard let preferredLanguage = Locale.preferredLanguages.first else {
            return
        }
        CLGeocoder().reverseGeocodeLocation(currentLocation, preferredLocale: Locale(identifier: preferredLanguage)) { placemark, error in
            guard error == nil else {
                return completion(.failure(LocationManagerError.invalidLocation))
            }
            guard let placemark = placemark?.last else {
                return completion(.failure(LocationManagerError.emptyPlacemark))
            }
            completion(.success(placemark))
        }
    }
}

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
                                                            lon: location.coordinate.longitude)) { weather, error in
                
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
        
        weatherTaskGroup.notify(queue: DispatchQueue.global()) {
            self.delegate?.didUpdateLocation(currentWeather, fiveDaysWeather)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}

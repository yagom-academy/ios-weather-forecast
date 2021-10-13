//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by Dasoll Park on 2021/10/13.
//

import Foundation
import CoreLocation

struct WeatherService {
    
    private var locationManager = LocationManager()
    
    func fetchCurrentWeatherByLocation(completion: @escaping (CurrentWeatherData) -> Void) {
        locationManager.getUserLocation { currentLocation in
            let url = makeURL(by: currentLocation.coordinate)
            
            self.fetchCurrentWeather(with: url, completion: { currentWeather in
                completion(currentWeather)
            })
        }
    }
    
    private func makeURL(by coordinate: CLLocationCoordinate2D) -> URL {
        let currentGeographic = WeatherAPI.current(.geographic(latitude: coordinate.latitude,
                                                               longitude: coordinate.longitude))
        
        do {
            let currentWeatherUrl = try currentGeographic.makeURL()
            return currentWeatherUrl
        } catch {
            return URL(fileURLWithPath: "")
        }
    }
    
    private func fetchCurrentWeather(
        with url: URL,
        completion: @escaping (CurrentWeatherData) -> Void
    ) {
        let networkManager = WeatherNetworkManager(session: URLSession(configuration: .default))
        let customDecoder = WeatherJSONDecoder()
        
        networkManager.fetchData(with: url) { result in
            switch result {
            case .success(let data):
                guard let currentWeather = try? customDecoder.decode(
                    CurrentWeatherData.self,
                    from: data
                ) else {
                    return
                }
                completion(currentWeather)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func obtainPlacemark(completion: @escaping (CLPlacemark) -> Void) {
        locationManager.lookUpCurrentPlacemark { placemark in
            completion(placemark)
        }
    }
}

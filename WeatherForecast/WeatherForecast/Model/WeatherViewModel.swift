//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/12.
//

import CoreLocation

final class WeatherViewModel {
    var currentData = Observerble<CurrentWeather>()
    var forecastData = Observerble<ForecastWeather>()
    var currentPlacemark: CLPlacemark?
    var isDataTaskError = Observerble<Bool>()
    
    private var locationManager = LocationManager()
    
    init() {
        self.locationManager.delegate = self
    }
}

extension WeatherViewModel {
    private func fetchingWeatherData<T: Decodable>(api: WeatherAPI,
                                                   type: T.Type,
                                                   completion: @escaping (T?, Error?) -> Void) {
        guard let coordinate = locationManager.getCoordinate() else {
            return
        }
        
        let networkManager = NetworkManager()
        let queryItems = [CoordinatesQuery.lat: String(coordinate.latitude),
                          CoordinatesQuery.lon: String(coordinate.longitude),
                          CoordinatesQuery.appid: "e6f23abdc0e7e9080761a3cfbbdafc90",
                          CoordinatesQuery.units: "metric"
        ]
        
        guard let url = URL.createURL(API: api, queryItems: queryItems) else { return }
        networkManager.dataTask(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(type, from: data)
                    completion(decodedData, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

extension WeatherViewModel: LocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        fetchingWeatherData(api: WeatherAPI.current, type: CurrentWeather.self) { currentWeather, error in
            
            guard let currentWeather = currentWeather,
                  let icon = currentWeather.weather.first?.icon,
                  let iconURL = URL(string: WeatherAPI.icon.url + icon),
                  error == nil else {
                self.isDataTaskError.value = true
                return
            }
            
            self.currentData.value = currentWeather
            
            NetworkManager().dataTask(url: iconURL) { result in
                switch result {
                case .success(let data):
                    self.currentData.value?.imageData = data
                case .failure(let error):
                    return
                        self.isDataTaskError.value = true
                }
            }
            
            self.locationManager.getAddress { result in
                switch result {
                case .success(let placemark):
                    self.currentPlacemark = placemark
                    self.currentData.value = currentWeather
                case .failure(let error):
                    self.isDataTaskError.value = true
                    return
                }
            }
        }
    }
}

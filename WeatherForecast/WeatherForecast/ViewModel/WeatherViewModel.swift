//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/12.
//

import CoreLocation

final class WeatherViewModel {
    var currentData = Observable<CurrentWeather>()
    var forecastData = Observable<ForecastWeather>()
    var currentPlacemark: CLPlacemark?
    var isDataTaskError: Observable<Bool>?
    
    var numberOfCellCount: Int? {
        return forecastData.value?.list.count
    }
    private var locationManager = LocationManager()
    
    init() {
        self.locationManager.delegate = self
    }
    
}

// MARK: - Private Method
extension WeatherViewModel {
    private func fetchingWeatherData<T: Decodable>(api: WeatherAPI,
                                                   type: T.Type,
                                                   completion: @escaping (T?, Error?) -> Void) {
        guard let coordinate = locationManager.getCoordinate() else {
            return
        }
        
        let queryItems = [CoordinatesQuery.lat: String(coordinate.latitude),
                          CoordinatesQuery.lon: String(coordinate.longitude),
                          CoordinatesQuery.appid: "e6f23abdc0e7e9080761a3cfbbdafc90",
                          CoordinatesQuery.units: "metric"
        ]
        
        guard let url = URL.createURL(API: api, queryItems: queryItems) else { return }
        
        let networkManager = NetworkManager()
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

// MARK: - Method
extension WeatherViewModel {
   
    func getAddress() -> String {
        guard let country = currentPlacemark?.name,
              let locality = currentPlacemark?.locality else {
            return ""
        }
        return locality + " " + country
    }
    
    func getFormattingTempature(_ tempature: Double?) -> String? {
        guard let tempature = tempature else {
            return nil
        }
        let numberFormat = "%.1f"
        
        return String(format: numberFormat, tempature).appending("°")
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> ForecastWeather.List? {
        return forecastData.value?.list[indexPath.row]
    }
    
    func getForecastTime(_ timeInterval: TimeInterval?) -> String {
        guard let timeInterval = timeInterval else {
            return ""
        }
        let formatter = DateFormatter()
        
        if let preferred = Locale.preferredLanguages.first {
            formatter.locale = Locale(identifier: preferred)
        }
        
        formatter.dateFormat = "MM/dd(E) HH시"
        return formatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }
    
    func refreshData() {
        locationManager.requestLocation()
    }
}

// MARK: - LocationManagerDelegate
extension WeatherViewModel: LocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        
        self.locationManager.getAddress { result in
            switch result {
            case .success(let placemark):
                self.currentPlacemark = placemark
            case .failure(_):
                self.isDataTaskError?.value = true
                return
            }
        }
        
        fetchingWeatherData(api: WeatherAPI.current, type: CurrentWeather.self) { currentWeather, error in
            
            guard let currentWeather = currentWeather,
                  let icon = currentWeather.weather.first?.icon,
                  let iconURL = URL(string: WeatherAPI.icon.url + icon),
                  error == nil else {
                self.isDataTaskError?.value = true
                return
            }
            
            NetworkManager().dataTask(url: iconURL) { result in
                switch result {
                case .success(let data):
                    self.currentData.value?.imageData = data
                case .failure(_):
                    self.isDataTaskError?.value = true
                }
            }
            
            self.currentData.value = currentWeather
        }
        
        fetchingWeatherData(api: WeatherAPI.forecast, type: ForecastWeather.self) { forecastWeather, error in
            
            guard let forecastWeather = forecastWeather,
                      error == nil else {
                self.isDataTaskError?.value = true
                return
            }
            
            self.forecastData.value = forecastWeather
        }
    }
}

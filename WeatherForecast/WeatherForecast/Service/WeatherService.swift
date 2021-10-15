//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/12.
//

import CoreLocation

final class WeatherService {
    
    var onCompleted: (() -> Void)?
    var currentImageData: Data? {
        return currentData?.imageData
    }
    
    private var currentData: CurrentWeather? {
        didSet {
            onCompleted?()
        }
    }
    
    private var forecastData: ForecastWeather? {
        didSet {
            onCompleted?()
        }
    }
    
    private var currentPlacemark: CLPlacemark?
    private var locationManager = LocationManager()
    private var weatherIconDataCache = NSCache<NSString, NSData>()
    
    init() {
        self.locationManager.delegate = self
    }
    
}

// MARK: - Private Method
extension WeatherService {
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
extension WeatherService {

    func getAddress() -> String {
        guard let country = currentPlacemark?.name,
              let locality = currentPlacemark?.locality else {
            return ""
        }
        return locality + " " + country
    }
    
    func currentWeatherTempature() -> (current: Double?, min: Double?, max: Double?) {
        let current = currentData?.main
        return (current: current?.temp, min: current?.tempMin, max: current?.tempMax)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> ForecastWeather.List? {
        return forecastData?.list[indexPath.row]
    }
    
    func refreshData() {
        locationManager.requestLocation()
    }
    
    private func getForecastTime(_ timeInterval: TimeInterval?) -> String {
        guard let timeInterval = timeInterval else {
            return ""
        }
        let formatter = DateFormatter()
        
        if let preferred = Locale.preferredLanguages.first {
            formatter.locale = Locale(identifier: preferred)
        }
        
        let dateFormat = "MM/dd(E) HH시"
        formatter.dateFormat = dateFormat
        return formatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }


    func getWeatherIconImage(at indexPath: IndexPath, completion: @escaping (Data) -> Void) {
        
        guard let icon = forecastData?.list[indexPath.row].weather.first?.icon,
              let cacheKey = forecastData?.list[indexPath.row].forecastTime,
              let url = URL(string: WeatherAPI.icon.url + icon) else {
            return
        }
        
        if let cacheData = weatherIconDataCache.object(forKey: NSString(string: String(cacheKey))) {
            completion(Data(cacheData))
            return
        }
        
        NetworkManager().dataTask(url: url) { result in
            switch result {
            case .success(let data):
                self.weatherIconDataCache.setObject(NSData(data: data),
                                                    forKey: NSString(string: String(cacheKey))
                )
                completion(data)
            case .failure(_):
                break
            }
        }
    }
}

// MARK: - LocationManagerDelegate
extension WeatherService: LocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        
        self.locationManager.getAddress { result in
            switch result {
            case .success(let placemark):
                self.currentPlacemark = placemark
            case .failure(_):
                return
            }
        }
        
        fetchingWeatherData(api: WeatherAPI.current, type: CurrentWeather.self) { currentWeather, error in
            
            guard let currentWeather = currentWeather,
                  let icon = currentWeather.weather.first?.icon,
                  let iconURL = URL(string: WeatherAPI.icon.url + icon),
                  error == nil else {
                return
            }
            
            NetworkManager().dataTask(url: iconURL) { result in
                switch result {
                case .success(let data):
                    self.currentData?.imageData = data
                case .failure(_):
                    return
                }
            }
            
            self.currentData = currentWeather
        }
        
        fetchingWeatherData(api: WeatherAPI.forecast, type: ForecastWeather.self) { forecastWeather, error in
            
            guard let forecastWeather = forecastWeather,
                  error == nil else {
                return
            }
            
            self.forecastData = forecastWeather
        }
    }
}

//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by yun on 2021/10/05.
//

import UIKit
import CoreLocation

final class LocationManager: CLLocationManager {
    var address: String?
    var fiveDaysData: FiveDaysForecast?
    var currentData: CurrentWeather?
    private var session = URLSession.shared
    
    func askUserLocation() {
        self.requestWhenInUseAuthorization()
        self.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let networkManager = NetworkManager()
        
        guard let longitude = manager.location?.coordinate.longitude,
              let latitude = manager.location?.coordinate.latitude,
              let fiveDaysUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast"),
        let currentWeather = URL(string: "https://api.openweathermap.org/data/2.5/weather")
        else  {
            return
        }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { placeMarks, error in
            guard error == nil else {
                return
            }
            
            guard let addresses = placeMarks,
                  let address = addresses.last?.name else {
                return
            }
            
            self.address = address
        }

        let requestInfo: Parameters = ["lat": latitude, "lon": longitude, "appid": networkManager.apiKey]
        let fiveDaysWeatherApi = WeatherApi(httpTask: .request(withUrlParameters: requestInfo), httpMethod: .get, baseUrl: fiveDaysUrl)
        let currentWeatherApi = WeatherApi(httpTask: .request(withUrlParameters: requestInfo), httpMethod: .get, baseUrl: currentWeather)
        parseCurrent(networkManager: networkManager, weatherApi: currentWeatherApi, session: self.session) {
            NotificationCenter.default.post(name: Notification.Name.completion, object: nil, userInfo: nil)
//            NotificationCenter.default.post(name: Notification.Name.dataIsNotNil, object: nil, userInfo: nil)
        }
        
        parseFiveDays(networkManager: networkManager, weatherApi: fiveDaysWeatherApi, session: self.session) {
            NotificationCenter.default.post(name: Notification.Name.dataIsNotNil, object: nil, userInfo: nil)
        }
    }
    
    private func parseCurrent(networkManager: NetworkManager, weatherApi: WeatherApi, session: URLSession, completion: @escaping () -> Void) {
        networkManager.getWeatherData(weatherAPI: weatherApi, session) { requestedData
            in
            do {
                self.currentData = try JSONDecoder().decode(CurrentWeather.self, from: requestedData)
            } catch {
                print("Decode Error")
            }
        }
    }
    
    private func parseFiveDays(networkManager: NetworkManager, weatherApi: WeatherApi, session: URLSession, completion: @escaping () -> Void) {
        networkManager.getWeatherData(weatherAPI: weatherApi, session) { requestedData in
            do {
                self.fiveDaysData = try JSONDecoder().decode(FiveDaysForecast.self, from: requestedData)
                completion()
            } catch {
                print("Decoding Error")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ViewController.showAlert(title: "🙋‍♀️", message: "새로고침을 해주세요.")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            ViewController.showAlert(title: "❌", message: "날씨 정보를 사용 할 수 없습니다.")
            break
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            manager.requestLocation()
            break
        }
    }
    
}

//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private var currentWeather: CurrentWeather?
    private var forecastFiveDays: ForecastFiveDays?
    private var locationManager: CLLocationManager!
    private var currentAddress: String = InitialValue.emptyString
    private var latitude: Double = InitialValue.latitude
    private var longitude: Double = InitialValue.longitude
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func setUpAPI(latitude: Double, longitude: Double) {
        decodeCurrentWeaterFromAPI(latitude: latitude, longitude: longitude)
        decodeForecastFiveDaysFromAPI(latitude: latitude, longitude: longitude)
    }
    
    private func decodeCurrentWeaterFromAPI(latitude: Double, longitude: Double) {
        let session = URLSession(configuration: .default)
        guard let url:URL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=bdc8daed0ec51c18dfc0d8b9c84bb17c&units=metric") else {
            return
        }
        let dataTask = session.dataTask(with: url) { data,_,error  in
            guard let data = data else {
                return
            }
            do {
                self.currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }

    private func decodeForecastFiveDaysFromAPI(latitude: Double, longitude: Double) {
        let session = URLSession(configuration: .default)
        guard let url:URL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=bdc8daed0ec51c18dfc0d8b9c84bb17c&units=metric") else {
            return
        }
        let dataTask = session.dataTask(with: url) { data,_,error  in
            guard let data = data else {
                return
            }
            do {
                self.forecastFiveDays = try JSONDecoder().decode(ForecastFiveDays.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    @IBAction func printCurrentWeather() {
        dump(currentWeather)
    }
    
    @IBAction func printForecastFiveDays() {
        dump(forecastFiveDays)
    }
    
    @IBAction func printCurrentAddress() {
        print(currentAddress)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locationManager.location?.coordinate else {
            return
        }
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        setUpAPI(latitude: latitude, longitude: longitude)
        convertToAddress(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func convertToAddress(latitude: Double, longitude: Double) {
        let geoCoder: CLGeocoder = CLGeocoder()
        let coordinate: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let local: Locale = Locale(identifier: InitialValue.emptyString)
        geoCoder.reverseGeocodeLocation(coordinate, preferredLocale: local) { place, _ in
            guard let address: [CLPlacemark] = place, let state = address.last?.administrativeArea, let city = address.first?.locality, let township = address.first?.subLocality else {
                return
            }
            self.currentAddress = "\(state) \(city) \(township)"
        }
    }
}

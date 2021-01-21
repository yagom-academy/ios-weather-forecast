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
    private var latitude: Double?
    private var longitude: Double?
    
    private func decodeCurrentWeaterFromAPI() {
        let session = URLSession(configuration: .default)
        guard let url:URL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=36&lon=128&appid=bdc8daed0ec51c18dfc0d8b9c84bb17c") else {
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
    
    private func decodeForecastFiveDaysFromAPI() {
        let session = URLSession(configuration: .default)
        guard let url:URL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=36&lon=128&appid=bdc8daed0ec51c18dfc0d8b9c84bb17c") else {
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
    
    @IBAction func printWeather() {
        dump(currentWeather)
    }
    
    @IBAction func printForecastFiveDays() {
        dump(forecastFiveDays)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        decodeCurrentWeaterFromAPI()
        decodeForecastFiveDaysFromAPI()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locationManager.location?.coordinate else {
            return
        }
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        
        print(latitude, longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //show error
    }
    
}



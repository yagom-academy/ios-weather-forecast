//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    var locationManager: CLLocationManager!
    var latitude: Double = App.latitude.coordinateValue
    var longitude: Double = App.longtitude.coordinateValue
    var address: String = App.address.value
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setCoordinateAndGetAddress()
        WeatherAPI.findCurrentWeather(latitude, longitude) { currentWeather in
            print("도시 : \(currentWeather.cityName)")
        }
        
        WeatherAPI.findFivedaysForecast(latitude, longitude) { forecastInfo in
            print("temperature : \(forecastInfo.list[0].temperature)")
            print("몇개야 : \(forecastInfo.timestampCount)")
            print("도시이름 : \(forecastInfo.city.name)")
            print("dateTime : \(forecastInfo.list[0].dateTimeText)")
        }
        print("위치정보 \(latitude), \(longitude)")
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func setCoordinateAndGetAddress() {
        setCoordinate()
        getAddress()
    }
    
    func setCoordinate() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        guard let coordinate = locationManager.location?.coordinate else {
            print("현재위치정보 알수없음")
            return
        }
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        print(latitude)
        print(longitude)
    }
    
    func getAddress() {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let locale = Locale(identifier: "Ko-kr")

        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { (placemarks, error) in
            guard error == nil, let _ = placemarks?.first else {
                print("위치정보없음")
                return
            }
            if let addressInfo: [CLPlacemark] = placemarks {
                guard let city = addressInfo.last?.administrativeArea,
                      let district = addressInfo.last?.locality else {
                    print("주소못찾음")
                    return
                }
                self.address = "\(String(describing: city)) \(String(describing: district))"
                print(self.address)
            }
        }
    }
}




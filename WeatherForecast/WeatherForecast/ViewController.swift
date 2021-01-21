//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    var locationManager: CLLocationManager!
    var latitude: Double = DefaultLocation.latitude.value
    var longitude: Double = DefaultLocation.longtitude.value
    var address: String = DefaultAddress.address.value
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setCoordinateAndGetAddress()
        WeatherAPI.findCurrentWeather(latitude, longitude) { currentWeather in
            //code
        }
        WeatherAPI.findFivedaysForecast(latitude, longitude) { forecastInfo in
            //code
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func setCoordinateAndGetAddress() {
        prepareCoordinate()
        getAddress()
    }
    
    func prepareCoordinate() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            setCoordinate()
        case .denied:
            print("사용자로부터 거절됨")
        default:
            return
        }
    }
    
    func setCoordinate() {
        guard let coordinate = locationManager.location?.coordinate else {
            print("현재위치정보(경도,위도) 알수없음")
            return
        }
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
    
    func getAddress() {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let locale = Locale(identifier: "Ko-kr")

        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { (placemarks, error) in
            guard error == nil, let _ = placemarks?.first else {
                print("에러있음/위치정보없음")
                return
            }
            guard let addressInfo: [CLPlacemark] = placemarks else {
                print("위치정보없음")
                return
            }
            guard let city = addressInfo.last?.administrativeArea,
                  let district = addressInfo.last?.locality else {
                print("주소못찾음")
                return
            }
            self.address = "\(String(describing: city)) \(String(describing: district))"
        }
    }
}

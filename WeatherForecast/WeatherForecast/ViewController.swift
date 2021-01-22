//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    var locationManager = CLLocationManager()
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
            print(Error.userDenied.message)
        default:
            return
        }
    }
    
    func setCoordinate() {
        guard let coordinate = locationManager.location?.coordinate else {
            print(Error.locationManagerError.message)
            return
        }
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
    
    func getAddress() {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let locale = Locale(identifier: "Ko-kr")

        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { (placemark, error) in
            guard error == nil,
                let addressInfo: [CLPlacemark] = placemark,
                let address = addressInfo.first,
                let city = address.administrativeArea,
                let district = address.locality else {
                print(Error.geocodeLocationError.message)
                return
            }
            self.address = "\(String(describing: city)) \(String(describing: district))"
        }
    }
}


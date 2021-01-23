//
//  WeatherLocationManager.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/23.
//

import Foundation
import CoreLocation

class WeatherLocationManager: NSObject {
    
    weak var delegate: WeatherLocationManagerDelegate?
    private let clLocationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    
    override init() {
        super.init()
        clLocationManager.delegate = self
    }
    
    func requestAuthorization() {
        clLocationManager.requestAlwaysAuthorization()
    }
}

extension WeatherLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            guard let currentLocation = clLocationManager.location else {
                return
            }
            
            self.delegate?.setLocation(currentLocation)
            requestAddress(of: currentLocation)
        }
    }
    
    private func requestAddress(of location: CLLocation) {
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                let currentAddress = self.makeAddress(from: placemark)

                self.delegate?.setAddress(currentAddress)
            }
        }
    }
    
    private func makeAddress(from placemark: CLPlacemark) -> String {
        let emptyString = ""
        let blank = " "
        var address = emptyString
        if let state = placemark.administrativeArea {
            address += state
        }
        if let city = placemark.locality {
            if address != emptyString {
                address += blank
            }
            address += city
        }
        if let district = placemark.subLocality {
            if address != emptyString {
                address += blank
            }
            address += district
        }
        return address
    }
}

//
//  LocationCoordinate.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/23.
//

import Foundation
import CoreLocation

class LocationCoordinate {
    var coordinate: CLLocationCoordinate2D?
    var address: String?
    
    func convertToAddressWith(coordinate: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                return
            }
            
            guard let placemark = placemarks?.first,
                  let administrativeArea = placemark.administrativeArea,
                  let locality = placemark.locality else {
                return
            }
            self.address = "\(administrativeArea) \(locality)"
        }
    }
}

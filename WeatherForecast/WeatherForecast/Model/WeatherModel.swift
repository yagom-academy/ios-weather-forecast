//
//  Weather.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/21.
//

import Foundation
import CoreLocation

class WeatherModel {
    static let shared = WeatherModel()
    private init() {}
    
    private(set) var item: CurrentWeather? = nil
    private(set) var address: String? = nil
    
    func fetchData(with coordinate: Coordinate, _ callback: @escaping (_ item: CurrentWeather?) -> Void) {
        let urlString = NetworkConfig.makeWeatherUrlString(type: .current, coordinate: coordinate)
        guard let url = URL(string: urlString) else {
             return
        }
        WeatherNetwork.loadData(from: url, with: CurrentWeather.self) { result in
            switch result {
            case .failure:
                callback(nil)
            case .success(let data):
                self.item = data
                self.coordinateToAddressString(data?.coordinate) { placemark in
                    guard let city = placemark?.administrativeArea,
                          let road = placemark?.thoroughfare else {
                        self.address = nil
                        return callback(data)
                    }
                    self.address = "\(city) \(road)"
                }
                callback(data)
            }
        }
    }
    
    func coordinateToAddressString(_ coordinate: Coordinate?, completionHandler: @escaping (CLPlacemark?)
                    -> Void ) {
        if let currentCoordinate = coordinate {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error == nil {
                    let firstLoaction = placemarks?[0]
                    completionHandler(firstLoaction)
                } else {
                    completionHandler(nil)
                }
            }
        } else {
            completionHandler(nil)
        }
    }
}

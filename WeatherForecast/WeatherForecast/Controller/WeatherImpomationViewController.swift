//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherImpormationViewController: UIViewController {
    private let locationManager = LocationManager()
    private let apiManager = APIManager()
    private let decodingManager = DecodingManager()
    private var currentLocation: CLLocation? = nil {
        didSet {
            processWeatherImpormation()
            getUserAddress()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserLocation()
       
    }
    
    private func getUserLocation() {
        locationManager.getUserLocation { location in
            self.currentLocation = location
        }
    }
    
    private func processWeatherImpormation() {
        guard let location = currentLocation else { return }
        let currentWeatherURL =
        WeatherURL.weatherCoordinates(latitude: location.coordinate.latitude,
                                      longitude: location.coordinate.longitude)
        let fiveDaysWeatherURL =
        WeatherURL.forecastCoordinates(latitude: location.coordinate.latitude,
                                      longitude: location.coordinate.longitude)
        
        self.getWeatherImpormation(request: currentWeatherURL,
                                   type: CurrentWeather.self) { result in
            if let result = result {
                debugPrint(result)
            }
        }
        
        self.getWeatherImpormation(request: fiveDaysWeatherURL,
                                   type: FiveDaysWeather.self) { result in
            if let result = result {
                debugPrint(result)
            }
        }
    }
    
    private func getUserAddress() {
        guard let location = currentLocation else { return }
        locationManager.getUserAddress(location: location) { address in
            switch address {
            case .success(let data):
                debugPrint(data)
            case .failure(let error):
                self.handlerError(error)
            }
        }
    }
    
    private func getWeatherImpormation<T: Decodable>(request: UrlGeneratable,
                                                     type: T.Type,
                                                     completion: @escaping (T?) -> Void) {
        self.apiManager.requestAPI(
            resource: APIResource(apiURL: request)) { result in
                switch result {
                case .success(let data):
                    guard let product =
                            try? self.decodingManager.decodeJSON(
                                type, from: data) else {
                                    return
                                }
                    completion(product)
                case .failure(let error):
                    self.handlerError(error)
                }
            }
    }
}

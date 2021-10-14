//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherImpormationViewController: UIViewController {
    private let locationManager = LocationManager()
    private let apiManager = APIManager()
    private let decodingManager = DecodingManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processWeatherImpormation()
    }
    
    private func processWeatherImpormation() {
        locationManager.getUserLocation { [weak self] location in
            guard let self = self else { return }
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
    }
    
    private func getUserAddress() {
        locationManager.getUserAddress { address in
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

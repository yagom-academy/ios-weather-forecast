//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    private let tableView = UITableView()
    
    private let locationManager = LocationManager()
    private let geocoderManager = GeocoderManager()
    private let apiManager = APIManager()
    private var coordinate = CLLocationCoordinate2D() {
        didSet {
//            fetchWeatherData(on: coordinate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        requestLocationAuthorization()
    }
}

extension WeatherViewController {
    private func setupTableView() {
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let layoutConstraintAttribute: [NSLayoutConstraint.Attribute] = [.leading, .trailing, .top, .bottom]
        let tableVeiwContraints = layoutConstraintAttribute.map { attr in
            return NSLayoutConstraint(item: tableView,
                                      attribute: attr,
                                      relatedBy: .equal,
                                      toItem: safeArea,
                                      attribute: attr,
                                      multiplier: 1,
                                      constant: 0)
        }
        NSLayoutConstraint.activate(tableVeiwContraints)

        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension WeatherViewController {
    private func requestLocationAuthorization() {
        locationManager.requestAuthorization { [weak self] coordinate in
            self?.coordinate = coordinate
        }
    }
    
    private func requestCoordinate() {
        locationManager.requestLocation()
    }
    
    private func fetchWeatherData(on coordinate: CLLocationCoordinate2D) {
        fetchWeatherAPI(CurrentWeather.self,
                        weatherURL: .weatherCoordinates(latitude: coordinate.latitude,
                                                        longitude: coordinate.longitude),
                        completion: { data in
                            dump(data)
                        })
        fetchWeatherAPI(FiveDaysWeather.self,
                        weatherURL: .forecastCoordinates(latitude: coordinate.latitude,
                                                         longitude: coordinate.longitude),
                        completion: { data in
                            dump(data)
                        })
        fetchAddress(on: coordinate)
    }
    
    private func fetchWeatherAPI<T: Decodable>(
        _ type: T.Type,
        weatherURL: WeatherURL,
        completion: @escaping((T) -> Void)
    ) {
        let apiResource = APIResource(apiURL: weatherURL)
        let weatherResultAction = generateResultAction(T.self, completion: completion)
        
        apiManager.requestAPI(resource: apiResource, completion: weatherResultAction)
    }
    
    private func fetchAddress(on coordinate: CLLocationCoordinate2D) {
        geocoderManager.requestAddress(on: coordinate) { result in
            switch result {
            case .success(let address):
                dump(address)
            case .failure(let error):
                self.handlerError(error)
            }
        }
    }
    
    private func generateResultAction<T: Decodable>(
        _ type: T.Type,
        completion: @escaping (T) -> Void
    ) -> ((Result<Data, Error>) -> Void) {
        func resultAction(result: Result<Data, Error>) {
            do {
                switch result {
                case .success(let data):
                    let decoder = DecodingManager()
                    let parsedData = try decoder.decodeJSON(T.self, from: data)
                    completion(parsedData)
                case .failure(let error):
                    handlerError(error)
                }
            } catch {
                handlerError(error)
            }
        }
        
        return resultAction
    }
}

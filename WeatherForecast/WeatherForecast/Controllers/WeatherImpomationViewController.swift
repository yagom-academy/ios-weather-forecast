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
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout())
    private let collectionViewDataSource = WeatherCollectionViewDataSource()
    private var currentLocation: CLLocation? = nil {
        didSet {
            processWeatherImpormation()
            getUserAddress()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserLocation()
        processCollectionView()
        registeredIdetifier()
        decidedCollectionViewLayout()
    }
    
    private func getUserLocation() {
        locationManager.getUserLocation { location in
            self.currentLocation = location
        }
    }
    
    private func processCollectionView() {
        collectionView.dataSource = collectionViewDataSource
        
    }
    
    private func registeredIdetifier() {
        collectionView.register(FiveDaysWeatherCell.self,
                                forCellWithReuseIdentifier: FiveDaysWeatherCell.identifier)
        collectionView.register(CurrentWeatherHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CurrentWeatherHeaderView.identifier)
    }
    
    private func decidedCollectionViewLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        collectionViewDataSource.decidedLayout(collectionView)
    }
    
    private func processWeatherImpormation() {
        guard let location = currentLocation else { return }
        let currentWeatherURL =
        WeatherURL.weatherCoordinates(latitude: location.coordinate.latitude,
                                      longitude: location.coordinate.longitude)
        let fiveDaysWeatherURL =
        WeatherURL.forecastCoordinates(latitude: location.coordinate.latitude,
                                       longitude: location.coordinate.longitude)
        
        getWeatherImpormation(request: currentWeatherURL,
                              type: CurrentWeather.self) { result in
            if let result = result {
                self.collectionViewDataSource.currentWeather = result
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }
        
        getWeatherImpormation(request: fiveDaysWeatherURL,
                              type: FiveDaysWeather.self) { result in
            if let result = result {
                self.collectionViewDataSource.fiveDaysWeather = result
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func getUserAddress() {
        guard let location = currentLocation else { return }
        locationManager.getUserAddress(location: location) { address in
            switch address {
            case .success(let data):
                self.collectionViewDataSource.currentAddress = data
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

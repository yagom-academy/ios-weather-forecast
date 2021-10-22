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
            fetchWeatherImpormation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRefreshControl()
        getUserLocation()
        processCollectionView()
        registeredIdetifier()
        decidedBackGroundImage()
        decidedCollectionViewLayout(layout: collectionViewDataSource)
    }
    
    private func getUserLocation() {
        locationManager.getUserLocation { location in
            self.currentLocation = location
        }
    }
    
    private func processCollectionView() {
        collectionView.dataSource = collectionViewDataSource
    }
    
    private func decidedBackGroundImage() {
        let backgroundImageView = UIImageView(image: UIImage(named: "BackGroundImage"))
        backgroundImageView.contentMode = .scaleAspectFill
        collectionView.backgroundView = backgroundImageView
    }
    
    private func registeredIdetifier() {
        collectionView.register(FiveDaysWeatherCell.self,
                                forCellWithReuseIdentifier: FiveDaysWeatherCell.identifier)
        collectionView.register(CurrentWeatherHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CurrentWeatherHeaderView.identifier)
    }
    
    private func decidedCollectionViewLayout(layout: CompositionalLayoutProtocol) {
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
        
        collectionView.collectionViewLayout = layout.layout()
        
    }
    
    private func fetchWeatherImpormation() {
            self.processWeatherImpormation {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                }
        }
    }
    
    private func processWeatherImpormation(completion: @escaping () -> Void) {
        
        guard let location = currentLocation else { return }
        let currentWeatherURL =
        WeatherURL.weatherCoordinates(latitude: location.coordinate.latitude,
                                      longitude: location.coordinate.longitude)
        let fiveDaysWeatherURL =
        WeatherURL.forecastCoordinates(latitude: location.coordinate.latitude,
                                       longitude: location.coordinate.longitude)
        
        let group = DispatchGroup()
        group.enter()
        self.getWeatherImpormation(request: fiveDaysWeatherURL,
                                   type: FiveDaysWeather.self) { result in
            
            if let result = result {
                self.collectionViewDataSource.fiveDaysWeather = result
            }
            group.leave()
        }
        
        group.enter()
        self.getWeatherImpormation(request: currentWeatherURL,
                                   type: CurrentWeather.self) { result in
            
            if let result = result {
                self.collectionViewDataSource.currentWeather = result
            }
            group.leave()
        }
        
        group.enter()
        self.locationManager.getUserAddress(location: location) { address in
            switch address {
            case .success(let data):
                self.collectionViewDataSource.currentAddress = data
            case .failure(let error):
                self.collectionViewDataSource.currentAddress = "주소 정보 없음"
                self.handlerError(error)
            }
            group.leave()
        }
        
        group.notify(queue: .global()) {
            completion()
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

extension WeatherImpormationViewController {
    private func setUpRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.tintColor = .systemGray
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        locationManager.refreshLocation()
    }
}

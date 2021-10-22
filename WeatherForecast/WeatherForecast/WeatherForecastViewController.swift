//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

typealias DataSource = UICollectionViewDiffableDataSource<WeatherHeader, FiveDayWeather.List>

final class WeatherForecastViewController: UIViewController {
    private var networkManager = NetworkManager()
    private let locationManager = LocationManager()
    private var imageManager = ImageManager()
    private var address = Address()
    private var currentWeatherHeader = WeatherHeader()
    private var fiveDayWeathers: [FiveDayWeather.List] = []
    private var collecionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private lazy var alert = initAlert()
    private let downloadDataGroup = DispatchGroup()
    
    private var dataSource: DataSource?
    private var snapshot: NSDiffableDataSourceSnapshot<WeatherHeader, FiveDayWeather.List>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "dark") {
            view.backgroundColor = UIColor(patternImage: image)
        }
        setupCollectionView()
        initData()
        configureRefreshControl()
    }
    
    private func initAlert() -> UIAlertController {
        if address.combined == " " {
            return UIAlertController.makeInvalidLocationAlert { alert in
                let latitude = alert.textFields?[0].text
                let longitude = alert.textFields?[1].text
                self.initData(latitude: latitude, longitude: longitude)
            }
        } else {
            return UIAlertController.makeValidLocationAlert{ alert in
                let latitude = alert.textFields?[0].text
                let longitude = alert.textFields?[1].text
                self.initData(latitude: latitude, longitude: longitude)
            } resetToCurrentLocationHandler: {
                self.initData()
            }
        }
    }
    
    private func initData(latitude: String? = nil, longitude: String? = nil) {
        var currentLocation: CLLocation?
        
        if let latitude = latitude,
           let latitudeNumber = Double(latitude),
           let longitude = longitude,
           let longitudeNumber = Double(longitude) {
            currentLocation = CLLocation(latitude: latitudeNumber, longitude: longitudeNumber)
        } else {
            currentLocation = locationManager.getGeographicCoordinates()
        }
        
        guard let location = currentLocation else {
            return
        }
        
        getAddress(of: location) { address in
            self.address = address
            self.alert = self.initAlert()
            self.getWeatherData(of: location, route: .current)
            self.getWeatherData(of: location, route: .fiveDay)
            self.downloadDataGroup.notify(queue: DispatchQueue.main) {
                self.makeSnapshot()
            }
        }
    }
    
    private func getAddress(of location: CLLocation?, completionHandler: @escaping (Address) -> Void) {
        locationManager.getAddress(of: location) { result in
            switch result {
            case .success(let addressElements):
                completionHandler(addressElements)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    
    
    private func getWeatherData(of location: CLLocation, route: WeatherForecastRoute) {
        let queryItems = WeatherForecastRoute.createParameters(latitude: location.coordinate.latitude,
                                                               longitude: location.coordinate.longitude)

        DispatchQueue.global().async {
            self.downloadDataGroup.enter()
            self.networkManager.request(with: route,
                                   queryItems: queryItems,
                                   httpMethod: .get,
                                   requestType: .requestWithQueryItems) { result in
                switch result {
                case .success(let data):
                    self.extract(data: data, period: route)
                case .failure(let networkError):
                    assertionFailure(networkError.localizedDescription)
                }
            }
        }
    }
    
    private func extract(data: Data, period: WeatherForecastRoute) {
        switch period {
        case .current:
            let parsedData = data.parse(to: CurrentWeather.self)
            filter(parsedData: parsedData)
        case .fiveDay:
            let parsedData = data.parse(to: FiveDayWeather.self)
            filter(parsedData: parsedData)
        }
    }
    
    private func filter<T: WeatherModel>(parsedData: Result<T, ParsingError>) {
        switch parsedData {
        case .success(let data):
            if let currentWeatherData = data as? CurrentWeather {
                imageManager.loadImage(with: imageURL(of: currentWeatherData.weather[0].icon)) { result in
                    switch result {
                    case .success(let image):
                        self.currentWeatherHeader = WeatherHeader(
                            address: self.address.combined,
                            minTemperature: currentWeatherData.main.minTemperature,
                            maxTemperature: currentWeatherData.main.maxTemperature,
                            temperature: currentWeatherData.main.temperature,
                            weatherIcon: image
                        )
                    case .failure(let error):
                        assertionFailure(error.localizedDescription)
                    }
                    self.downloadDataGroup.leave()
                }
            } else if let fiveDayWeatherData = data as? FiveDayWeather {
                self.fiveDayWeathers = fiveDayWeatherData.list
                downloadDataGroup.leave()
            }
        case .failure(let parsingError):
            assertionFailure(parsingError.localizedDescription)
        }
    }
    
    private func imageURL(of icon: String) -> String {
        return "https://openweathermap.org/img/w/\(icon).png"
    }
}

extension WeatherForecastViewController {
    
    private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<WeatherHeader, FiveDayWeather.List>()
        snapshot.appendSections([currentWeatherHeader])
        snapshot.appendItems(fiveDayWeathers, toSection: currentWeatherHeader)
        self.snapshot = snapshot
        dataSource?.apply(snapshot)
    }
    
    private func setupCollectionView() {
        collecionView.backgroundColor = .clear
        setCollectionViewLayoutConfiguration()
        setAutoLayoutCollectionView()
        registerCell()
        registerHeader()
    }
    
    private func setCollectionViewLayoutConfiguration() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .supplementary
        configuration.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collecionView.collectionViewLayout = layout
    }
    
    private func setAutoLayoutCollectionView() {
        collecionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collecionView)
        NSLayoutConstraint.activate([
            collecionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collecionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collecionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collecionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func registerCell() {
        let cellRegistration = UICollectionView.CellRegistration
        <WeatherForecastCustomCell, FiveDayWeather.List> { (cell, indexPath, fiveDayWeatherItem) in
            let iconID = fiveDayWeatherItem.weather[0].icon
            let currentImageURL = self.imageURL(of: iconID)
            cell.urlString = currentImageURL
            self.imageManager.loadImage(with: currentImageURL) { result in
                if currentImageURL == cell.urlString {
                    switch result {
                    case .success(let image):
                        cell.configure(image: image)
                    case .failure:
                        cell.configure(image: UIImage(systemName: "photo"))
                    }
                }
            }
            cell.configure(date: fiveDayWeatherItem.UnixForecastTime,
                           temparature: fiveDayWeatherItem.main.temperature)
        }
        
        dataSource = DataSource(collectionView: collecionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
    }
    
    private func registerHeader() {
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <WeatherHeaderView>(elementKind: UICollectionView.elementKindSectionHeader)
        { headerView, elementKind, indexPath in
            let headerItem = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            
            
            let buttonType: LocationSelectButtonType = self.address.combined == " " ? .invalid : .valid
            headerView.configureLocationSelectButton(button: buttonType) {
                self.present(self.alert, animated: true, completion: nil)
            }
            headerView.configureContents(from: headerItem)
        }
        
        dataSource?.supplementaryViewProvider = { (collecionView, elementKind, indexpath) in
            return collecionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                        for: indexpath)
        }
    }
}

extension WeatherForecastViewController {
    private func configureRefreshControl() {
        collecionView.refreshControl = UIRefreshControl()
        collecionView.refreshControl?.tintColor = .systemRed
        collecionView.refreshControl?.addTarget(self,
                                                action: #selector(handleRefreshControl),
                                                for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        initData()
        self.collecionView.refreshControl?.endRefreshing()
    }
}


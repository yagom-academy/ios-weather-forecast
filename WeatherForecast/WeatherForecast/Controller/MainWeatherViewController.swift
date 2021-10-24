//
//  MainWeatherViewController - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class MainWeatherViewController: UIViewController {
    //MARK: Properties
    private let locationManager = WeatherLocationManager()
    private var userAddress: String?
    private var weatherForOneDay: WeatherForOneDay?
    private var fiveDayWeatherForecast: FiveDayWeatherForecast?
    private let prepareInformationDispatchGroup = DispatchGroup()
    private var updateWorkItem: DispatchWorkItem?
    private let tableView = UITableView()
    private let headerView = MainWeatherHeaderView()
    private let tableViewDataSource = MainWeatherTableViewDataSource()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        setUpTableView()
        setUpRefreshControl()
    }
}
 
//MARK:- LocationManager
extension MainWeatherViewController {
    private func setUpLocationManager() {
        locationManager.delegate = self
        guard CLLocationManager.significantLocationChangeMonitoringAvailable() else {
            return
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
}

//MARK:- Conforms to CLLocationManagerDelegate
extension MainWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        
        updateWorkItem?.cancel()
        updateWorkItem = nil
        
        updateWorkItem = DispatchWorkItem(block: { [weak self] in
            guard let self = self else {
                return
            }
            self.prepareWeatherInformation(with: lastLocation) { userAddress, weatherForOneDay, weatherForFiveDay in
                if self.userAddress != userAddress {
                    self.userAddress = userAddress
                    self.updateUserAddressLabel(to: userAddress)
                }
                if self.weatherForOneDay != weatherForOneDay {
                    self.weatherForOneDay = weatherForOneDay
                    self.updateHeaderView(to: weatherForOneDay)
                }
                if self.fiveDayWeatherForecast != weatherForFiveDay {
                    self.fiveDayWeatherForecast = weatherForFiveDay
                    self.updateTableView(to: weatherForFiveDay?.weatherForFiveDays)
                }
                self.tableView.refreshControl?.endRefreshing()
                if self.locationManager.isSignificantMonitoringEnabled == false {
                    self.locationManager.startMonitoringSignificantLocationChanges()
                }
            }
        })
        if let updateWorkItem = updateWorkItem {
            DispatchQueue.main.async(execute: updateWorkItem)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
        tableView.refreshControl?.endRefreshing()
    }
}

//MARK:- Load Information
extension MainWeatherViewController {
    private func prepareWeatherInformation(with location: CLLocation, completionHandler: @escaping (String?, WeatherForOneDay?, FiveDayWeatherForecast?) -> Void) {
        let userCoordinate = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let commonWeatherAPIParameter = CommonWeatherAPIParameter(responseFormat: nil, numberOfTimestamps: nil, unitsOfMeasurement: MeasurementType.getMeasurementType(by: Locale.preferredLanguages.first), language: nil)
        let callType = CallType.geographicCoordinates(coordinate: userCoordinate, parameter: commonWeatherAPIParameter)
        let weatherForOneDayAPI = WeatherAPI(callType: callType, forecastType: .current)
        let fivedayWeatherForecastAPI = WeatherAPI(callType: callType, forecastType: .fiveDays)
        var userAddress: String?
        var weatherForOneDay: WeatherForOneDay?
        var weatherForFiveDay: FiveDayWeatherForecast?
        
        prepareInformationDispatchGroup.enter()
        AddressManager.generateAddress(from: location) { [self] in
            switch $0 {
            case .failure(_):
                break
            case .success(let address):
                userAddress = address
            }
            prepareInformationDispatchGroup.leave()
        }
        
        prepareInformationDispatchGroup.enter()
        NetworkManager.request(using: weatherForOneDayAPI) { [self] result in
            switch result {
            case .failure(_):
                break
            case .success(let data):
                weatherForOneDay = ParsingManager.decode(from: data, to: WeatherForOneDay.self)
            }
            prepareInformationDispatchGroup.leave()
        }
        
        prepareInformationDispatchGroup.enter()
        NetworkManager.request(using: fivedayWeatherForecastAPI) { [self] result in
            switch result {
            case .failure(_):
                break
            case .success(let data):
                weatherForFiveDay = ParsingManager.decode(from: data, to: FiveDayWeatherForecast.self)
            }
            prepareInformationDispatchGroup.leave()
        }
        
        prepareInformationDispatchGroup.notify(queue: .main) {
            guard let updateWorkItem = self.updateWorkItem,
                  updateWorkItem.isCancelled == false else {
                return
            }
            completionHandler(userAddress, weatherForOneDay, weatherForFiveDay)
        }
    }
}

//MARK:- UI
extension MainWeatherViewController {
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.register(MainWeatherTableViewCell.self, forCellReuseIdentifier: MainWeatherTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
        tableView.dataSource = tableViewDataSource
        tableView.tableHeaderView = headerView
        sizeHeaderViewHeightToFit()
        
        headerView.changeLocationDelegate = self
    }
    
    private func setUpRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadNewData), for: .valueChanged)
    }
    
    private func updateUserAddressLabel(to newInformation: String?) {
        guard let newInformation = newInformation else {
            return
        }
        headerView.configure(addressData: newInformation)
    }
    
    private func updateHeaderView(to newInformation: WeatherForOneDay?) {
        guard let newInformation = newInformation else {
            return
        }
        if let imageId = newInformation.weatherConditionCodes?.last?.iconId {
            let imageAPI = ImageAPI(imageId: imageId)
            
            NetworkManager.imageRequest(using: imageAPI) { [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(_):
                        break
                    case .success(let image):
                        headerView.configure(image: image)
                    }
                }
            }
        }
        headerView.configure(weatherData: newInformation)
    }
    
    private func sizeHeaderViewHeightToFit() {
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
    }
    
    private func updateTableView(to newInformation: [WeatherForOneDay]?) {
        guard let newInformation = newInformation else {
            return
        }
        tableViewDataSource.fiveDayWeatherList = newInformation
        tableView.reloadData()
    }
    
    @objc private func loadNewData() {
        if locationManager.isSignificantMonitoringEnabled {
            locationManager.stopMonitoringSignificantLocationChanges()
        }
        locationManager.requestLocation()
    }
}

extension MainWeatherViewController: ChangeLocationDelegate {
    func locationChangeRequested() {
        showLocationChangeAlert()
    }
    
    private func showLocationChangeAlert() {
        let alert = UIAlertController(title: "ChangeLocationAlert_Title".localized(), message: "ChangeLocationAlert_Message".localized(), preferredStyle: .alert)
        alert.addTextField { latitudeTextField in
            latitudeTextField.placeholder = "ChangeLocationAlert_LatitudeTextField_Placeholder".localized()
            latitudeTextField.keyboardType = .decimalPad
        }
        alert.addTextField { longitudeTextField in
            longitudeTextField.placeholder = "ChangeLocationAlert_LongitudeTextField_Placeholder".localized()
            longitudeTextField.keyboardType = .decimalPad
        }
        let changeAction = UIAlertAction(title: "ChangeLocationAlert_ChangeAction_Title".localized(), style: .default) { [weak self, weak alert] _ in
            guard let self = self, let alert = alert else {
                return
            }
            if let latitudeText = alert.textFields?.first?.text, let longitudeText = alert.textFields?.last?.text,
               let latitude = Double(latitudeText), let longitude = Double(longitudeText) {
                let desiredLocation = CLLocation(latitude: latitude, longitude: longitude)
                self.locationManager(self.locationManager, didUpdateLocations: [desiredLocation])
            }
        }
        let setCurrentLocationAction = UIAlertAction(title: "ChangeLocationAlert_SetCurrentLocationAction_Title".localized(), style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            if self.locationManager.isSignificantMonitoringEnabled {
                self.locationManager.stopMonitoringSignificantLocationChanges()
            }
            self.locationManager.requestLocation()
        }
        let cancelAction = UIAlertAction(title: "ChangeLocationAlert_CancelAction_Title".localized(), style: .cancel, handler: nil)
        
        alert.addAction(changeAction)
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            alert.addAction(setCurrentLocationAction)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

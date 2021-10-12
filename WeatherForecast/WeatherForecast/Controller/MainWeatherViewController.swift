//
//  MainWeatherViewController - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class MainWeatherViewController: UIViewController {
    //MARK: Properties
    private let locationManager = CLLocationManager()
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
        locationManager.delegate = self
        guard CLLocationManager.significantLocationChangeMonitoringAvailable() else { return }
        locationManager.startMonitoringSignificantLocationChanges()
        setUpTableView()
    }
}

//MARK:- Conforms to CLLocationManagerDelegate
extension MainWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
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
            self?.prepareWeatherInformation(with: lastLocation) { userAddress, weatherForOneDay, weatherForFiveDay in
                if self?.userAddress != userAddress {
                    self?.userAddress = userAddress
                    self?.updateUserAddressLabel(to: userAddress)
                }
                if self?.weatherForOneDay != weatherForOneDay {
                    self?.weatherForOneDay = weatherForOneDay
                    self?.updateHeadView(to: weatherForOneDay)
                }
                if self?.fiveDayWeatherForecast != weatherForFiveDay {
                    self?.fiveDayWeatherForecast = weatherForFiveDay
                    self?.updateTableView(to: weatherForFiveDay?.weatherForFiveDays)
                }
            }
        })
        if let updateWorkItem = updateWorkItem {
            DispatchQueue.main.async(execute: updateWorkItem)
        }
    }
}

//MARK:- Load Information
extension MainWeatherViewController {
    private func prepareWeatherInformation(with location: CLLocation, completionHandler: @escaping (String?, WeatherForOneDay?, FiveDayWeatherForecast?) -> Void) {
        let userCoordinate = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let callType = CallType.geographicCoordinates(coordinate: userCoordinate, parameter: nil)
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
    }
    
    private func updateUserAddressLabel(to newInformation: String?) {
        guard let newInformation = newInformation else {
            return
        }
        headerView.configure(addressData: newInformation)
        sizeHeaderViewHeightToFit()
    }
    
    private func updateHeadView(to newInformation: WeatherForOneDay?) {
        guard let newInformation = newInformation else {
            return
        }
        headerView.configure(weatherData: newInformation)
        sizeHeaderViewHeightToFit()
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
}

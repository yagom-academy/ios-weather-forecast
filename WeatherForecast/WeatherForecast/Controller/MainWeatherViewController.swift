//
//  MainWeatherViewController - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class MainWeatherViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private var userAddress: String?
    private var weatherForOneDay: WeatherForOneDay?
    private var fiveDayWeatherForecast: FiveDayWeatherForecast?
    private let prepareInformationDispatchGroup = DispatchGroup()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        guard CLLocationManager.significantLocationChangeMonitoringAvailable() else { return }
        locationManager.startMonitoringSignificantLocationChanges()
    }
}

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
        
        prepareAddressInformation(with: lastLocation)
        prepareWeatherInformation(with: lastLocation.coordinate)
        prepareInformationDispatchGroup.notify(queue: .main) {
            print("정보들이 다 준비되었습니다.")
            
        }
    }
}

extension MainWeatherViewController {
    private func prepareAddressInformation(with location: CLLocation) {
        prepareInformationDispatchGroup.enter()
        AddressManager.generateAddress(from: location) { [self] in
            switch $0 {
            case .failure(_):
                break
            case .success(let address):
                updateUserAddress(to: address)
            }
            prepareInformationDispatchGroup.leave()
        }
    }
    
    private func prepareWeatherInformation(with coordinate: CLLocationCoordinate2D) {
        let userCoordinate = Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let callType = CallType.geographicCoordinates(coordinate: userCoordinate, parameter: nil)
        let weatherForOneDayAPI = WeatherAPI(callType: callType, forecastType: .current)
        let fivedayWeatherForecastAPI = WeatherAPI(callType: callType, forecastType: .fiveDays)
        
        prepareInformationDispatchGroup.enter()
        NetworkManager.request(using: weatherForOneDayAPI) { [self] result in
            switch result {
            case .failure(_):
                break
            case .success(let data):
                updateWeather(from: data, to: &self.weatherForOneDay)
            }
            prepareInformationDispatchGroup.leave()
        }
        prepareInformationDispatchGroup.enter()
        NetworkManager.request(using: fivedayWeatherForecastAPI) { [self] result in
            switch result {
            case .failure(_):
                break
            case .success(let data):
                updateWeather(from: data, to: &self.fiveDayWeatherForecast)
            }
            prepareInformationDispatchGroup.leave()
        }
    }
    
    private func updateUserAddress(to newAddress: String) {
        if userAddress != newAddress {
            userAddress = newAddress
        }
    }
    
    private func updateWeather<T: Decodable>(from data: Data, to oldInformation: inout T) where T: Equatable {
        guard let newInformation = ParsingManager.decode(from: data, to: T.self) else {
            return
        }
        if oldInformation != newInformation {
            oldInformation = newInformation
        }
    }
}

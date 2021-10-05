//
//  MainWeatherViewController - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class MainWeatherViewController: UIViewController {
    private let locationManager = CLLocationManager()
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
                print(address)
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
                guard let parsedData = ParsingManager.decode(from: data, to: WeatherForOneDay.self) else {
                    return
                }
                weatherForOneDay = parsedData
            }
            prepareInformationDispatchGroup.leave()
        }
        prepareInformationDispatchGroup.enter()
        NetworkManager.request(using: fivedayWeatherForecastAPI) { [self] result in
            switch result {
            case .failure(_):
                break
            case .success(let data):
                guard let parsedData = ParsingManager.decode(from: data, to: FiveDayWeatherForecast.self) else {
                    return
                }
                fiveDayWeatherForecast = parsedData
            }
            prepareInformationDispatchGroup.leave()
        }
    }
    
}


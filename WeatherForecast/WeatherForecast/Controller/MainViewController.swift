//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class MainViewController: UIViewController {
    enum ConvertLocationError: Error {
        case invalidLocation
    }
    
    private let tableViewController = TableViewController()
    private let locationViewController = LocationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllers()
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(showValidLocationAlert),
                         name: .showValidLocationAlert,
                         object: nil)
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(showInValidLocation),
                         name: .showInValidLocationAlert,
                         object: nil)
    }
    
    @objc private func showInValidLocation() {
        self.present(inValidLocationAlert, animated: true)
    }
    
    private func addViewControllers() {
        add(tableViewController)
        add(locationViewController)
        self.view.addSubview(tableViewController.view)
        tableViewController.view.frame = self.view.bounds
    }
    
    @objc func showValidLocationAlert() {
        self.present(validLocationAlert, animated: true)
    }
    
    private lazy var validLocationAlert: UIAlertController = {
        let alert = UIAlertController(title: "위치설정",
                                      message: "변경할 좌표를 선택해주세요",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "변경",
                                      style: .default) { _ in
            switch self.convertToValidLocation(alert.textFields) {
            case .failure(let error):
                NotificationCenter
                    .default
                    .post(name: .cleanTalbeView,
                          object: nil)
                
            case .success(let location):
                self.deleteTextField(alert.textFields)
                
                let sessionDelegate = OpenWeatherSessionDelegate()
                let networkManager = WeatherNetworkManager()
                
                networkManager
                    .fetchOpenWeatherData(latitudeAndLongitude: location,
                                          requestPurpose: .currentWeather,
                                          sessionDelegate.session)
                
                networkManager
                    .fetchOpenWeatherData(latitudeAndLongitude: location,
                                          requestPurpose: .forecast,
                                          sessionDelegate.session)
            }
        })
        
        alert.addAction(UIAlertAction(title: "현재 위치로 재설정", style: .default) { _ in
            NotificationCenter
                .default
                .post(name: .requestLocationAgain,
                      object: nil)
        })
        
        alert.addTextField { [self] field in
            let latitude = self.locationViewController.getLocation()?.coordinate.latitude
            field.text = String(describing: latitude ?? CLLocationDegrees())

            field.placeholder = "위도"
        }
        
        alert.addTextField { field in
            let longitude = self.locationViewController.getLocation()?.coordinate.longitude
            field.text = String(describing: longitude ?? CLLocationDegrees())
            field.placeholder = "경도"
        }
        return alert
    }()
    
    private lazy var inValidLocationAlert: UIAlertController = {
        let alert = UIAlertController(title: "위치변경",
                                      message: "날씨를 받아올 위치의 위도와 경도를 입력해주세요",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "변경",
                                      style: .default) { _ in
            switch self.convertToValidLocation(alert.textFields) {
            case .failure(let error):
                NotificationCenter
                    .default
                    .post(name: .cleanTalbeView,
                          object: nil)
                
            case .success(let location):
                self.deleteTextField(alert.textFields)
                
                let sessionDelegate = OpenWeatherSessionDelegate()
                let networkManager = WeatherNetworkManager()
                
                networkManager
                    .fetchOpenWeatherData(latitudeAndLongitude: location,
                                          requestPurpose: .currentWeather,
                                          sessionDelegate.session)
                
                networkManager
                    .fetchOpenWeatherData(latitudeAndLongitude: location,
                                          requestPurpose: .forecast,
                                          sessionDelegate.session)
            }
        })
        
        alert.addTextField { [self] field in
            let latitude = self.locationViewController.getLocation()?.coordinate.latitude
            field.text = String(describing: latitude ?? CLLocationDegrees())
            field.placeholder = "위도"
        }
        
        alert.addTextField { field in
            let longitude = self.locationViewController.getLocation()?.coordinate.longitude
            field.text = String(describing: longitude ?? CLLocationDegrees())
            field.placeholder = "경도"
        }
        
        return alert
    }()
}

extension MainViewController {
    private func deleteTextField(_ fields: [UITextField]?) {
        guard let fields = fields else {
            return
        }
        for field in fields {
            field.text = nil
        }
    }
    
    private func changeToLocationType(_ latitude: String?, _ longitude: String?) -> Location? {
        guard let latitude = latitude, let longitude = longitude else {
            return nil
        }
        
        guard let lat = CLLocationDegrees(latitude),
              let long = CLLocationDegrees(longitude) else {
            return nil
        }
        
        return Location(lat, long)
    }
    
    private func isValidLocationRange(_ location: Location?) -> Bool {
        let maxLatitudeNumber: CLLocationDegrees = 90
        let minLatitudeNumber: CLLocationDegrees = -90
        let maxLongitudeNumber: CLLocationDegrees = 180
        let minLongitudeNumber: CLLocationDegrees = -180
        
        if let location = location,
           location.latitude < maxLatitudeNumber,
           location.latitude > minLatitudeNumber,
           location.longitude < maxLongitudeNumber,
           location.longitude > minLongitudeNumber {
            return true
        } else {
            return false
        }
    }
    
    private func convertToValidLocation(_ fields: [UITextField]?) -> Result<Location, Error> {
        let convertedLocation = changeToLocationType(fields?.first?.text, fields?.last?.text)
        if let convertedLocation = convertedLocation,
           self.isValidLocationRange(convertedLocation) {
            return .success(convertedLocation)
        } else {
            return .failure(ConvertLocationError.invalidLocation)
        }
    }
}

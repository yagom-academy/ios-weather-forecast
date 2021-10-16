//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/12.
//

import CoreLocation

protocol WeatherServiceDelegate: AnyObject {
    func didUpdatedWeatherDatas(current: CurrentWeather?, forecast: FiveDaysWeather?)
}

final class WeatherService {
    static let shared = WeatherService()
 
    weak var delegate: WeatherServiceDelegate?
    
    private var locationManager = LocationManager()
    private var currentData: CurrentWeather?
    private var fiveDaysData: FiveDaysWeather? {
        didSet {
            delegate?.didUpdatedWeatherDatas(current: self.currentData, forecast: self.fiveDaysData)
        }
    }
    
    private init() {
        self.locationManager.delegate = self
    }
    
}


// MARK: - Method
extension WeatherService {
    
    func getAddress(comletion: @escaping (String) -> Void) {
        locationManager.getAddress { result  in
            switch result {
            case .success(let placeMark):
                guard let country = placeMark.name,
                      let locality = placeMark.locality else {
                    return
                }
                comletion(locality + " " + country)
            case .failure(_):
                return
            }
        }

    }

    func getCellViewModel(at indexPath: IndexPath) -> FiveDaysWeather.List? {
        return fiveDaysData?.list[indexPath.row]
    }
    
    func refreshData() {
        locationManager.requestLocation()
    }
}

// MARK: - LocationManagerDelegate
extension WeatherService: LocationManagerDelegate {
    func didUpdateLocation(_ currnet: CurrentWeather?, _ fiveDays: FiveDaysWeather?) {
        self.currentData = currnet
        self.fiveDaysData = fiveDays
    }
}

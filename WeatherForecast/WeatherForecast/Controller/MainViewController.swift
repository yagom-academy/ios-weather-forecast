//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    private var locationService: LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.setUpDelegate()
        setUpWeatherData { address, currentData, fivedayData in
            DispatchQueue.main.async {
                print(" --> 주소 : \(address)")
                print(" --> 현재 : \(currentData)")
                print(" --> 5일 : \(fivedayData)")
            }
        }
    }
}

extension MainViewController {
    private func setUpWeatherData(completion: @escaping (String, CurrentWeatherData, FiveDayWeatherData) -> Void) {
        locationService.requestLocation { location in
            DispatchQueue.global().async {
                var currentAddress: String?
                var currentWeather: CurrentWeatherData?
                var fivedayWeather: FiveDayWeatherData?
                let preparingGroup = DispatchGroup()
                
                preparingGroup.enter()
                self.showAddressInfomation(location) { address in
                    currentAddress = address
                    preparingGroup.leave()
                }
                
                preparingGroup.enter()
                let currentWeatherAPI = WeatherAPI.current(.geographic(location.coordinate))
                self.fetchCurrentWeatherData(of: currentWeatherAPI) { decodedData in
                    currentWeather = decodedData
                    preparingGroup.leave()
                }
                
                preparingGroup.enter()
                let fivedayWeatherAPI = WeatherAPI.fiveday(.geographic(location.coordinate))
                self.fetchFiveDayWeatherData(of: fivedayWeatherAPI) { decodedData in
                    fivedayWeather = decodedData
                    preparingGroup.leave()
                }
                
                preparingGroup.wait()
                guard let currentAddress = currentAddress else {
                    NSLog("\(#function) - 주소 요청 실패")
                    return
                }
                guard let currentWeather = currentWeather else {
                    NSLog("\(#function) - 현재 날씨 요청 실패")
                    return
                }
                guard let fivedayWeather = fivedayWeather else {
                    NSLog("\(#function) - 5일 날씨 요청 실패")
                    return
                }
                completion(currentAddress, currentWeather, fivedayWeather)
            }
        }
    }
}

// MARK: - 주소 불러오기
extension MainViewController {
    private func showAddressInfomation(_ location: CLLocation, completion: @escaping (String) -> Void) {
        let koreaLocale = Locale(identifier: "ko-kr")
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: koreaLocale) { placemarks, error in
            guard error == nil else {
                NSLog("\(#function) - \(String(describing: error?.localizedDescription))")
                return
            }
            guard let placeMark = placemarks?.last else {
                NSLog("\(#function) - 지역 정보 없음")
                return
            }
            guard let administrativeArea = placeMark.administrativeArea,
                  let thoroughfare = placeMark.thoroughfare else {
                NSLog("\(#function) - 주소 정보 없음")
                return
            }
            let address: String = "\(administrativeArea) \(thoroughfare)"

            completion(address)
        }
    }
}

// MARK: - 날씨 정보 불러오기
extension MainViewController {
    private func fetchCurrentWeatherData(of api: WeatherAPI, completion: @escaping (CurrentWeatherData) -> Void) {
        guard let url = api.makeURL() else {
            NSLog("\(#function) - URL 생성 실패")
            return
        }
        
        let networkManager = WeatherNetworkManager(session: URLSession(configuration: .default))
        networkManager.requestData(with: url) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase)
                do {
                    let decodedInstance: CurrentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
                    completion(decodedInstance)
                } catch {
                    NSLog("\(#function) - \(error.localizedDescription)")
                }
            case .failure(let error):
                NSLog("\(#function) - \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchFiveDayWeatherData(of api: WeatherAPI, completion: @escaping (FiveDayWeatherData) -> Void) {
        guard let url = api.makeURL() else {
            NSLog("\(#function) - URL 생성 실패")
            return
        }
        
        let networkManager = WeatherNetworkManager(session: URLSession(configuration: .default))
        networkManager.requestData(with: url) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase)
                do {
                    let decodedInstance: FiveDayWeatherData = try decoder.decode(FiveDayWeatherData.self, from: data)
                    completion(decodedInstance)
                } catch {
                    NSLog("\(#function) - \(error.localizedDescription)")
                }
            case .failure(let error):
                NSLog("\(#function) - \(error.localizedDescription)")
            }
        }
    }
}

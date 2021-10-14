//
//  WeatherDataViewModel.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/14.
//

import CoreLocation

class WeatherDataViewModel {
    private var locationService: LocationService
    
    private(set) var currentAddress: String?
    private(set) var currentWeatherData: CurrentWeatherData?
    private var fivedayWeatherData: FiveDayWeatherData? {
        willSet {
            guard let listResource = newValue?.intervalWeathers else {
                NSLog("IntervalWeathers nil")
                return
            }
            intervalWeatherInfos = listResource
        }
    }
    private(set) var intervalWeatherInfos: [IntervalWeatherData] = []
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
}

extension WeatherDataViewModel {
    func setUpWeatherData(completion: @escaping () -> Void) {
        locationService.requestLocation { location in
            DispatchQueue.global().async {
                let preparingGroup = DispatchGroup()

                preparingGroup.enter()
                self.fetchAddressInfomation(location) { address in
                    self.currentAddress = address
                    preparingGroup.leave()
                }

                preparingGroup.enter()
                let currentWeatherAPI = WeatherAPI.current(.geographic(location.coordinate))
                self.fetchCurrentWeatherData(of: currentWeatherAPI) { decodedData in
                    self.currentWeatherData = decodedData
                    preparingGroup.leave()
                }

                preparingGroup.enter()
                let fivedayWeatherAPI = WeatherAPI.fiveday(.geographic(location.coordinate))
                self.fetchFiveDayWeatherData(of: fivedayWeatherAPI) { decodedData in
                    self.fivedayWeatherData = decodedData
                    preparingGroup.leave()
                }

                preparingGroup.wait()
                completion()
            }
        }
    }
}

// MARK: - 주소 불러오기
extension WeatherDataViewModel {
    private func fetchAddressInfomation(_ location: CLLocation, completion: @escaping (String) -> Void) {
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
extension WeatherDataViewModel {
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

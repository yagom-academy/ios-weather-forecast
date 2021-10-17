//
//  WeatherDataViewModel.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/14.
//

import CoreLocation

class WeatherDataViewModel {
    private var locationService: LocationService
    
    private(set) var currentAddress: String = ""
    private(set) var currentTemperature: Double = 0
    private(set) var currentMinimumTemperature: Double = 0
    private(set) var currentMaximumTemperature: Double = 0
    private(set) var currentWeatherIconName: String = ""
    private(set) var intervalWeatherInfos: [FiveDayWeatherData.IntervalWeatherData] = []
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
}

// MARK: - 데이터 Set-Up
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
                self.requestWeatherData(type: CurrentWeatherData.self, of: currentWeatherAPI) { currentweather in
                    self.currentWeatherIconName = currentweather.conditions[0].iconName
                    self.currentTemperature = currentweather.mainInformation.temperature
                    self.currentMinimumTemperature = currentweather.mainInformation.minimumTemperature
                    self.currentMaximumTemperature = currentweather.mainInformation.maximumTemperature
                    preparingGroup.leave()
                }

                preparingGroup.enter()
                let fivedayWeatherAPI = WeatherAPI.fiveday(.geographic(location.coordinate))
                self.requestWeatherData(type: FiveDayWeatherData.self, of: fivedayWeatherAPI) { fivedayWeather in
                    self.intervalWeatherInfos = fivedayWeather.intervalWeathers
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
    private func requestWeatherData<T: Decodable>(type: T.Type = T.self, of api: WeatherAPI,
                                                  completion: @escaping (T) -> Void) {
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
                    let decodedInstance: T = try decoder.decode(T.self, from: data)
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

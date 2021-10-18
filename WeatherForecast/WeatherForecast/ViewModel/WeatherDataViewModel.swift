//
//  WeatherDataViewModel.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/14.
//

import CoreLocation

class WeatherDataViewModel {
    private var locationService: LocationService
    private weak var delegate: Requirable?
    private var currentLocation: CLLocation? {
        didSet {
            delegate?.reloadWeatherData(nil)
        }
    }
    
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
    func setDelegate(from delegate: Requirable) {
        self.delegate = delegate
    }
    
    func updateUserInputLocation(_ latitude: Double, _ longitude: Double) {
        self.currentLocation = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func setUpWeatherData(completion: @escaping () -> Void) {
        if let location = currentLocation {
            requestWeatherData(location) {
                completion()
            }
        } else {
            locationService.requestLocation { result in
                if let location = result {
                    self.currentLocation = location
                } else {
                    self.delegate?.requireUserLocation()
                }
            }
        }
    }
    
    private func requestWeatherData(_ location: CLLocation, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            let preparingGroup = DispatchGroup()

            preparingGroup.enter()
            self.fetchAddressInfomation(location) {
                preparingGroup.leave()
            }
            preparingGroup.enter()
            self.fetchCurrentWeatherData(location) {
                preparingGroup.leave()
            }
            preparingGroup.enter()
            self.fetchFiveDayWeatherData(location) {
                preparingGroup.leave()
            }

            preparingGroup.wait()
            completion()
        }
    }
}

// MARK: - 주소 불러오기
extension WeatherDataViewModel {
    private func fetchAddressInfomation(_ location: CLLocation, completion: @escaping () -> Void) {
        self.requestAddressInfomation(location) { address in
            self.currentAddress = address
            completion()
        }
    }
    
    private func requestAddressInfomation(_ location: CLLocation, completion: @escaping (String) -> Void) {
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
    private func fetchCurrentWeatherData(_ location: CLLocation, completion: @escaping () -> Void) {
        let currentWeatherAPI = WeatherAPI.current(.geographic(location.coordinate))
        self.requestWeatherData(type: CurrentWeatherData.self, of: currentWeatherAPI) { currentweather in
            self.currentWeatherIconName = currentweather.conditions[0].iconName
            self.currentTemperature = currentweather.mainInformation.temperature
            self.currentMinimumTemperature = currentweather.mainInformation.minimumTemperature
            self.currentMaximumTemperature = currentweather.mainInformation.maximumTemperature
            completion()
        }
    }
    
    private func fetchFiveDayWeatherData(_ location: CLLocation, completion: @escaping () -> Void) {
        let fivedayWeatherAPI = WeatherAPI.fiveday(.geographic(location.coordinate))
        self.requestWeatherData(type: FiveDayWeatherData.self, of: fivedayWeatherAPI) { fivedayWeather in
            self.intervalWeatherInfos = fivedayWeather.intervalWeathers
            completion()
        }
    }
    
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

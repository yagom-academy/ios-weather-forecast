//
//  WeatherDataManger.swift
//  WeatherForecast
//
//  Created by 호싱잉, 잼킹 on 2021/09/28.
//

import UIKit
import CoreLocation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case emptyData
    case decodingError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .emptyData:
            return "Empty Data"
        case .decodingError:
            return "Decoding Error"
        case .unknown:
            return "Unknown"
        }
    }
}

final class WeatherDataManager {
    static let shared = WeatherDataManager()
    private init() {}
    
    var latitude: Double?
    var longitude: Double?
    var location: CLLocation {
        if let lat = latitude, let lon = longitude {
            return CLLocation(latitude: lat, longitude: lon)
        }
        return CLLocation()
    }
    let group = DispatchGroup()
    let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    var currentWeatherData: CurrentWeather?
    var fiveDaysWeatherData: FivedaysWeather?
}

extension WeatherDataManager {
    func fetchCurrentWeather(location: CLLocation ,completion: @escaping (Result<CurrentWeather, APIError>) -> ()) {
        let url = generateURL(path: .current)
        self.fetch(url: url, location: location, completion: completion)
    }
    
    func fetchFiveDaysWeather(location: CLLocation, completion: @escaping (Result<FivedaysWeather, APIError>) -> ()) {
        let url = generateURL(path: .fiveDays)
        self.fetch(url: url, location: location, completion: completion)
    }
    
    func fetchWeatherDatas(location: CLLocation, completion: @escaping () -> ()) {
        group.enter()
        concurrentQueue.async {
            self.fetchCurrentWeather(location: location) { result in
                switch result {
                case .success(let currentWeatherData):
                    self.currentWeatherData = currentWeatherData
                case .failure(let error):
                    NotificationCenter.default.post(name: NSNotification.Name.fetchFailedAlert, object: nil, userInfo: ["fetchFailedMessage" : "\(error.localizedDescription)의 이유로 데이터를 가져올 수 없습니다. 네트워크 연결을 확인 후 다시 시도해주세요."])
                }
                self.group.leave()
            }
        }
        
        group.enter()
        concurrentQueue.async {
            self.fetchFiveDaysWeather(location: location) { result in
                switch result {
                case .success(let fiveDaysWeatherData):
                    self.fiveDaysWeatherData = fiveDaysWeatherData
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
                self.group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    private func generateURL(path: URLResource.PathType) -> URL? {
        let builder = URLBuilder()
        builder.pathType = path
        if let latitude = WeatherDataManager.shared.latitude, let longitude = WeatherDataManager.shared.longitude {
            builder.addQueries([
                URLResource.QueryParam(name: "\(ParamName.lat)", value: latitude.toString()),
                URLResource.QueryParam(name: "\(ParamName.lon)", value: longitude.toString()),
                URLResource.QueryParam(name: "\(ParamName.appid)", value: AppID.jamkingID),
                URLResource.QueryParam(name: "\(ParamName.units)", value: Units.metric),
                URLResource.QueryParam(name: "\(ParamName.lang)", value: Lang.korea)
            ])
        }
        let urlResource = URLResource()
        let url = builder.buildWeatherURL(resource: urlResource)
        return url
    }
}

extension WeatherDataManager: JSONDecodable {
    private func fetch<ParsingType: Decodable>(url: URL?, location: CLLocation ,completion: @escaping (Result<ParsingType, APIError>) -> ()) {
        guard let url = url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.invalidURL))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.emptyData))
                return
            }
            
            do {
                let data = try self.decodeJSON(ParsingType.self, from: data)
                completion(.success(data))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}



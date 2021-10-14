//
//  WeatherDataManger.swift
//  WeatherForecast
//
//  Created by 호싱잉, 잼킹 on 2021/09/28.
//

import Foundation
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
}

extension WeatherDataManager {
    //    func fetchCurrentWeather()  {
    //        let url = generateURL(path: .current)
    //        self.fetch(url: url) { (result: Result<CurrentWeather, APIError>) in
    //            switch result {
    //            case .success(let currentWeather):
    //                return print(currentWeather)
    //            case .failure(let error):
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
    func fetchCurrentWeather(completion: @escaping (Result<CurrentWeather, APIError>) -> ()) {
        let url = generateURL(path: .current)
        self.fetch(url: url, completion: completion)
    }
    
    func fetchFiveDaysWeather(completion: @escaping (Result<FivedaysWeather, APIError>) -> ()) {
        let url = generateURL(path: .fiveDays)
        self.fetch(url: url, completion: completion)
    }
    
    //    func fetchFiveDaysWeather() {
    //        let url = generateURL(path: .fiveDays)
    //        self.fetch(url: url) { (result: Result<FivedaysWeather, APIError>) in
    //            switch result {
    //            case .success(let currentWeather):
    //                return print(currentWeather)
    //            case .failure(let error):
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
    
    
    private func generateURL(path: URLResource.PathType) -> URL? {
        let builder = URLBuilder()
        builder.pathType = path
        if let latitude = WeatherDataManager.shared.latitude, let longitude = WeatherDataManager.shared.longitude {
            builder.addQueries([
                URLResource.QueryParam(name: "\(ParamName.lat)", value: String(latitude)),
                URLResource.QueryParam(name: "\(ParamName.lon)", value: String(longitude)),
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
    private func fetch<ParsingType: Decodable>(url: URL?, completion: @escaping (Result<ParsingType, APIError>) -> ()) {
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



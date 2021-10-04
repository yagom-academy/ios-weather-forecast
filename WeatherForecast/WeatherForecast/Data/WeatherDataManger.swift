//
//  WeatherDataManger.swift
//  WeatherForecast
//
//  Created by 호싱잉, 잼킹 on 2021/09/28.
//

import Foundation

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
    private let appId = "af361cc4ac7bf412119174d64ba296ff"
    
    private init() {}

    func fetchCurrentWeather() {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=37.557297&lon=126.991934&appid=\(appId)&units=metric&lang=kr"
        self.fetch(urlString: url) { (result: Result<CurrentWeather, APIError>) in
            switch result {
            case .success(let currentWeather):
                return print(currentWeather)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchFiveDaysWeather() {
        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=37.557297&lon=126.991934&appid=\(appId)&units=metric&lang=kr"
        self.fetch(urlString: url) { (result: Result<FivedaysWeather, APIError>) in
            switch result {
            case .success(let currentWeather):
                return print(currentWeather)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension WeatherDataManager: JSONDecodable {
    private func fetch<ParsingType: Decodable>(urlString: String, completion: @escaping (Result<ParsingType, APIError>) -> ()) {
        guard let url = URL(string: urlString) else {
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



//
//  WeatherApi.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation

//protocol NetworkManagerDelegate {
//    func decodeWeatherData(data: Data) -> FiveDaysForecast
//}
    
final class NetworkManager {
    enum APIError: Error, LocalizedError {
        case filePathError
        case plistError
        
        var description: String {
            switch self {
            case .filePathError:
                return "FilePath doesn't exist"
            case .plistError:
                return "Plist's name doesn't exist"
            }
        }
    }
    
    private let router = Router<WeatherApi>()
    var weatherData: Data?
    var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist") else {
                return APIError.filePathError.description
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                return APIError.plistError.description
            }
            
            return value
        }
    }
    
    func getCurrentWeatherData(weatherAPI: WeatherApi, _ session: URLSession) {
        router.request(weatherAPI, session) { data in
//            do {
//                let decodedData = try JSONDecoder().decode(CurrentWeather.self, from: data)
//                self.decodeWeatherData(data: data)
//            } catch {
//
//            }
//        }
        }
    
//    func getFiveDaysWeatherData(weatherAPI: WeatherApi, _ session: URLSession) {
//        router.request(weatherAPI, session) { data in
//            let decodedData = JSONDecoder().decode(FiveDaysForecast.self, from: <#T##Data#>)
//        }
//    }
    }
}

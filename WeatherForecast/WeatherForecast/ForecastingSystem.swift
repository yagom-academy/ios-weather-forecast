
import Foundation

enum SystemFeature {
    case currentWeather
    case fiveDaysForecasting
    
    var pathKeyword: String {
        switch self {
        case .currentWeather:
            return "weather"
        case .fiveDaysForecasting:
            return "forecast"
        }
    }
}

struct ForecastingSystem {
    private let myKey = "2ce6e0d6185aa981602d52eb6e89fa16"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private var requestCall: URL?
    private let coordinateToSearch = GeographicCoordinate(latitude: 37.4943514, longitude: 127.0633398)
    
    func searchForCurrentWeather() {
        guard let requestCall = makeRequestCall(for: .currentWeather) else {
            print("URL 생성 실패")
            return
        }
        
        let dataTask = makeDataTask(with: requestCall, for: .currentWeather)
        dataTask.resume()
    }
    
    func searchForFiveDaysForecasting() {
        guard let requestCall = makeRequestCall(for: .fiveDaysForecasting) else {
            print("URL 생성 실패")
            return
        }
        
        let dataTask = makeDataTask(with: requestCall, for: .fiveDaysForecasting)
        dataTask.resume()
    }
}
extension ForecastingSystem {
    private func makeRequestCall(for feature: SystemFeature) -> URL? {
        let requestURL = URL(string: "\(baseURL)/\(feature.pathKeyword)?lat=\(coordinateToSearch.latitude)&lon=\(coordinateToSearch.longitude)&units=metric&appid=\(myKey)")
        return requestURL
    }
    
    private func makeDataTask(with requestURL: URL, for feature: SystemFeature) -> URLSessionDataTask {
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: requestURL) { (data, response, error) in
            if let resultData = data {
                switch feature {
                case .currentWeather:
                    let forecastInformation = try? JSONDecoder().decode(CurrentWeatherInformation.self, from: resultData)
                    print(forecastInformation ?? "")
                case .fiveDaysForecasting:
                    let forecastInformation = try? JSONDecoder().decode(FiveDaysForecastingInformation.self, from: resultData)
                    print(forecastInformation ?? "")
                }
            }
        }
        
        return dataTask
    }
}

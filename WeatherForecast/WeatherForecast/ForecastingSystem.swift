
import Foundation

struct ForecastingSystem {
    private let myKey = "2ce6e0d6185aa981602d52eb6e89fa16"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let temperatureUnit = "metric"
    private let coordinateToSearch = GeographicCoordinate(latitude: 37.4943514, longitude: 127.0633398)
    
    public enum NetworkError: Error {
        case invalidURL
        case invalidData
        case decodingFailure
    }

    public func announceCurrentWeather(result: @escaping (Result<CurrentWeatherInformation,NetworkError>) -> Void) {
        guard let requestURL = makeRequestURL(with: "weather") else {
            print(NetworkError.invalidURL)
            return
        }
        
        fetchResource(url: requestURL, completion: result)
    }
    
    public func announceFiveDaysForecasting(result: @escaping (Result<FiveDaysForecastingInformation,NetworkError>) -> Void) {
        guard let requestURL = makeRequestURL(with: "forecast") else {
            print(NetworkError.invalidURL)
            return
        }
        
        fetchResource(url: requestURL, completion: result)
    }
}

extension ForecastingSystem {
    private func makeRequestURL(with keyword: String) -> URL? {
        if let validateURL =  URL(string:"\(baseURL)/\(keyword)?lat=\(coordinateToSearch.latitude)&lon=\(coordinateToSearch.longitude)&units=\(temperatureUnit)&appid=\(myKey)") {
            return validateURL
        }
        return nil
    }
    
    private func fetchResource<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let receivedData = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let forecastInformation = try JSONDecoder().decode(T.self, from: receivedData)
                completion(.success(forecastInformation))
            } catch {
                completion(.failure(.decodingFailure))
            }
        }
        dataTask.resume()
    }
}


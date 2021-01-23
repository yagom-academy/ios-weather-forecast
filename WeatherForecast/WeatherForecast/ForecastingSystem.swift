
import Foundation

struct ForecastingSystem {
    private let urlMaker = URLMaker()
    private let coordinateToSearch = GeographicCoordinate(latitude: 37.4943514, longitude: 127.0633398)
    
    public enum NetworkError: Error {
        case invalidData
        case decodingFailure
    }

    public func announceCurrentWeather(result: @escaping (Result<CurrentWeatherInformation,NetworkError>) -> Void) {
        guard let requestURL = urlMaker.makeRequestURL(with: "weather", searching: coordinateToSearch) else {
            preconditionFailure("URL 생성 error")
        }
        
        fetchResource(url: requestURL, completion: result)
    }
    
    public func announceFiveDaysForecasting(result: @escaping (Result<FiveDaysForecastingInformation,NetworkError>) -> Void) {
        guard let requestURL = urlMaker.makeRequestURL(with: "forecast", searching: coordinateToSearch) else {
            preconditionFailure("URL 생성 error")
        }
        
        fetchResource(url: requestURL, completion: result)
    }
}

extension ForecastingSystem {
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


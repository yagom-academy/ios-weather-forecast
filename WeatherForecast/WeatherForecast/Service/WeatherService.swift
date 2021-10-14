//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by Dasoll Park on 2021/10/13.
//

import Foundation
import CoreLocation

struct WeatherService {
    
    private var locationManager = LocationManager()
    
    func obtainPlacemark(completion: @escaping (CLPlacemark) -> Void) {
        locationManager.lookUpCurrentPlacemark { placemark in
            completion(placemark)
        }
    }
    
    func fetchByLocation<Model: Decodable>(completion: @escaping (Model) -> Void) {
        locationManager.getUserLocation { location in
            let url = makeURL(by: location.coordinate)
            
            self.parseFetchedModel(with: url, completion: { currentWeather in
                completion(currentWeather)
            })
        }
    }
}

extension WeatherService {
    
    private func makeURL(by coordinate: CLLocationCoordinate2D) -> URL {
        let currentGeographic = WeatherAPI.current(.geographic(latitude: coordinate.latitude,
                                                               longitude: coordinate.longitude))
        
        do {
            let currentWeatherUrl = try currentGeographic.makeURL()
            return currentWeatherUrl
        } catch {
            print(error)
            return URL(fileURLWithPath: "")
        }
    }
    
    private func parseFetchedModel<Model: Decodable>(
        with url: URL,
        completion: @escaping (Model) -> Void
    ) {
        let networkManager = WeatherNetworkManager(session: URLSession(configuration: .default))
        
        networkManager.fetchData(with: url) { result in
            switch result {
            case .success(let data):
                guard let weatherData = self.decode(type: Model.self, from: data) else { return }
                completion(weatherData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func decode<Model>(type: Model.Type, from data: Data) -> Model? where Model: Decodable {
        let decoder = WeatherJSONDecoder()
        let parsedData = try? decoder.decode(type, from: data)
        return parsedData
    }
}

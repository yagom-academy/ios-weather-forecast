//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김준건 on 2021/09/29.
//

import Foundation

struct NetworkManager {
    private let rangeOfSuccessState = 200...299
    //    let watherforcast = WeatherForreCast()
    //    func getWeatherForecast(of period: Path,
    //                            latitude: Int,
    //                            longitude: Int,
    //                            apiKey: String?,
    //                            completionHandler: @escaping (Result<Data, Error>) -> Void)
    //    {
    //        guard let apiKey = apiKey else { return }
    //                var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/\(period.period)?")
    ////        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/\(period.path)?")
    //        let latitudeQuery = URLQueryItem(name: "lat", value: latitude.description)
    //        let longitudeQuery = URLQueryItem(name: "lon", value: longitude.description)
    //        let apiKeyQuery = URLQueryItem(name: "appid", value: apiKey)
    //
    //        urlComponents?.queryItems = [latitudeQuery, longitudeQuery, apiKeyQuery]
    //        guard let url = urlComponents?.url else { return }
    //
    //        URLSession.shared.dataTask(with: url) { (data, response, error) in
    //            if let error = error {
    //                DispatchQueue.main.async {
    //                    completionHandler(.failure(error))
    //                }
    //                return
    //            }
    //
    //            guard let response = response as? HTTPURLResponse,
    //            rangeOfSuccessState.contains(response.statusCode) else {
    //                DispatchQueue.main.async {
    //                    completionHandler(.failure(NetworkError.badResponse))
    //                }
    //                return
    //            }
    //
    //            guard let data = data else {
    //                DispatchQueue.main.async {
    //                    completionHandler(.failure(NetworkError.dataIntegrityError))
    //                }
    //                return
    //            }
    //
    //            DispatchQueue.main.async {
    //                completionHandler(.success(data))
    //            }
    //        }.resume()
    //    }
}

//
//  APIDataReceiver.swift
//  WeatherForecast
//
//  Created by 김동빈 on 2021/01/22.
//

import Foundation

class APIJSONDecoder <T: Decodable> {
    private let defaultSession = URLSession(configuration: .default)
        
    func decodeAPIData(url: URL, result: @escaping (T) -> ()) {
        let datatask = defaultSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(InternalError.failedServeData)
                return
            }
            
            do {
                let decodeResult: T = try JSONDecoder().decode(T.self, from: data)
                result(decodeResult)
            } catch {
                print(error)
            }
        }
        
        datatask.resume()
    }
}

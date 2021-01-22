//
//  APIDataReceiver.swift
//  WeatherForecast
//
//  Created by 김동빈 on 2021/01/22.
//

import Foundation

struct APIJSONDecoder <T: Decodable> {
    let defaultSession = URLSession(configuration: .default)
    var datatask: URLSessionDataTask
    var result: T
    
    mutating func decodeAPIData(url: URL) {
        datatask = defaultSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(InternalError.failedServeData)
                return
            }
            
            do {
                result = try JSONDecoder().decode(T.self, from: data)
            } catch {
                print(error)
            }
        }
        
        datatask.resume()
    }
}

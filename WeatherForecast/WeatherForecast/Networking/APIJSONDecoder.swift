//
//  APIDataReceiver.swift
//  WeatherForecast
//
//  Created by 김동빈 on 2021/01/22.
//

import Foundation

class APIJSONDecoder <T: Decodable> {
    let defaultSession = URLSession(configuration: .default)
    var decodeResult: T?
        
    func decodeAPIData(url: URL, result: @escaping (T) -> ()) {
        let datatask = defaultSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(InternalError.failedServeData)
                return
            }
            
            do {
                self.decodeResult = try JSONDecoder().decode(T.self, from: data)
            } catch {
                print(error)
            }
            
            result(self.decodeResult!)
        }
        
        datatask.resume()
    }
}

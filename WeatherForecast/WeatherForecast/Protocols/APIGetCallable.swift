//
//  APIClient.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/09/28.
//

import Foundation

protocol APIGetCallable: JSONDecodable {
    
}

extension APIGetCallable {
    func callGetAPI<T, S>(_ responseType: T.Type,
                          _ errorType: S.Type,
                          url: String,
                          _ completion: @escaping (Result<T, Error>) -> Void
    ) where T: Decodable, S: Decodable & Error {
        let successRange = 200...299
        guard let url = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard error == nil else {
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    return
                }
                
                guard successRange.contains(httpResponse.statusCode) else {
                    if let data = data {
                        let parsedError = try self.decodedJSON(S.self, from: data)
                        completion(.failure(parsedError))
                        return
                    }
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                let parsedData = try self.decodedJSON(T.self, from: data)
                completion(.success(parsedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

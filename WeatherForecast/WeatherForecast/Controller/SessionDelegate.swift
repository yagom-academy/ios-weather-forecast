//
//  SessionDelegate.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/13.
//

import Foundation

final class OpenWeatherSessionDelegate: NSObject, URLSessionDataDelegate {
    lazy var session: URLSession = {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        return session
    }()
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print(error)
            return
        }
    }
        
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        let requestData = proposedResponse.data
        
        do  {
            let decodedData = try Parser().decode(requestData, to: FiveDaysForecastData.self)
            print(decodedData)
        } catch {
            print(error)
        }
        
        completionHandler(proposedResponse)
    }
}

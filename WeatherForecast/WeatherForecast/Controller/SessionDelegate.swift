//
//  SessionDelegate.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/13.
//

import Foundation

final class OpenWeatherSessionDelegate: NSObject, URLSessionDataDelegate {
    
    private var forcast: Data?
    private var current: Data?
    
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
        if let path = dataTask.currentRequest?.url?.pathComponents,
           path.contains(URLPath.forecast.rawValue) {
            self.forcast = requestData
        } else {
            self.current = requestData
        }
        
        completionHandler(proposedResponse)
    }
}

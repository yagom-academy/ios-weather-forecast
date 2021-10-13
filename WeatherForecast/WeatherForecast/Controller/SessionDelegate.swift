//
//  SessionDelegate.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/13.
//

import Foundation

final class OpenWeatherSessionDelegate: NSObject, URLSessionDataDelegate {
    
    private var holder: Holder?
    
    lazy var session: URLSession = {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        return session
    }()
    
    class Holder {
        var forcast: FiveDaysForecastData?
        var current: CurrentWeather?
        
        init(_ path: URLPath, _ data: Data) {
            switch path {
            case .forecast:
                do {
                    let decodedData = try  Parser().decode(data, to: FiveDaysForecastData.self)
                    self.forcast = decodedData
                } catch {
                    print(error)
                }
            case .weather:
                do {
                    let decodedData = try  Parser().decode(data, to: CurrentWeather.self)
                    self.current = decodedData
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getHolder() -> Holder? {
        return self.holder
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print(error)
            return
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        
        let requestData = proposedResponse.data
        let pathCompnent = dataTask.currentRequest?.url?.pathComponents.last
        
        if let pathComponent = pathCompnent,
           let path = URLPath(rawValue: pathComponent) {
            let holder = Holder(path, requestData)
            self.holder = holder
        }
        
        completionHandler(proposedResponse)
    }
}

//
//  SessionDelegate.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/13.
//

import Foundation
import UIKit.UIImage

extension Notification.Name {
    static let reloadTableView = Notification.Name("reload TableView")
}

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
        let pathCompnent = dataTask.currentRequest?.url?.pathComponents.last
        
        if let path = pathCompnent {
            WeatherDataHolder.shared.generate(path, requestData)
            session.finishTasksAndInvalidate()
            NotificationCenter.default.post(name: .reloadTableView,
                                            object: nil)
        }
        
        completionHandler(proposedResponse)
    }
}

class WeatherDataHolder {
    static let shared = WeatherDataHolder()
    
    var forcast: FiveDaysForecastData?
    var current: CurrentWeather?
    
    private init() { }
    
    func generate(_ path: String, _ data: Data) {
        switch path {
        case PathOptions.Paths.forecast.rawValue:
            do {
                let decodedData = try  Parser().decode(data, to: FiveDaysForecastData.self)
                self.forcast = decodedData
            } catch {
                print(error)
            }
            
        case PathOptions.Paths.current.rawValue:
            do {
                let decodedData = try  Parser().decode(data, to: CurrentWeather.self)
                self.current = decodedData
            } catch {
                print(error)
            }
            
        default:
            print("")
        }
    }
}

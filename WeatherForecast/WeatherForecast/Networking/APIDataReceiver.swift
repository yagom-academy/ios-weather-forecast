//
//  APIDataReceiver.swift
//  WeatherForecast
//
//  Created by 김동빈 on 2021/01/22.
//

import Foundation

class WeatherDataReceiver {
    let defaultSession = URLSession(configuration: .default)
    var results: Data?
    
    // 임시 URL
    let currentWeatherAPIURL = "https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=f08f782b840c2494b77e036d6bf2f3de"
    let ForecastFiveDaysAPIURL = "https://api.openweathermap.org/data/2.5/forecast?lat=35&lon=139&appid=f08f782b840c2494b77e036d6bf2f3de"
    
    func serveAPIData() throws -> Data {
        guard let url = URL(string: currentWeatherAPIURL) else {
            throw InternalError.InvalidURL
        }

        defaultSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            self.results = data
        }.resume()
        
        return results!
    }
}

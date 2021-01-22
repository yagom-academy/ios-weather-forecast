//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    var currentWeather: CurrentWeather?
    var forecastFiveDays: ForecastFiveDays?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try decodeCurrentWeather(latitude: 35, longitude: 139)
        } catch {
            print(error)
        }
        
        sleep(3)
        
        print(currentWeather!.city)
    }
    

}

// MARK: Decode
extension ViewController {
    func decodeCurrentWeather(latitude: Double, longitude: Double) throws {
        let apiURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=f08f782b840c2494b77e036d6bf2f3de"
        guard let url = URL(string: apiURL) else {
            throw InternalError.invalidURL
        }

        let apiDecoder = APIJSONDecoder<CurrentWeather>()
        apiDecoder.decodeAPIData(url: url) { result in
            self.currentWeather = result
        }
    }
    
//    func decodeFore
}

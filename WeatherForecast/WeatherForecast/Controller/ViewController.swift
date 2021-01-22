//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        currentWeatherTest()
    }
    
}

//extension ViewController {
//    func currentWeatherTest() {
//        let apiURL = "https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=f08f782b840c2494b77e036d6bf2f3de"
//
//        let task = URLSession.shared.dataTask(with: URL(string: apiURL)!, completionHandler: { data, response, error in
//            guard let data = data, error == nil else {
//                print("failed")
//                return
//            }
//
//
//            var result: CurrentWeather?
//            do {
//                result = try JSONDecoder().decode(CurrentWeather.self, from: data)
//            } catch {
//                print(error)
//            }
//
//            guard let currentWeather = result else {
//                return
//            }
//
//            print(currentWeather.city)
//            print(currentWeather.temperature.current)
//            print(currentWeather.temperature.feelsLike)
//            print(currentWeather.temperature.humidity)
//            print(currentWeather.temperature.max)
//            print(currentWeather.temperature.min)
//            print(currentWeather.weather[0].icon)
//        })
//
//        task.resume()
//    }
//}

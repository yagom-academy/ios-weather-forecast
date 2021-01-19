//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    var currentWeather: ForecastFiveDays?
    
    private func decodeCurrentWeaterFromAPI() {
        let session = URLSession(configuration: .default)
        guard let url:URL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=35&lon=125&appid=4119f1d1ea30af76104279475caf11c7") else {
            return
        }

        let dataTask = session.dataTask(with: url) { data,_,error  in
            guard let data = data else {
                return
            }

            do {
                self.currentWeather = try JSONDecoder().decode(ForecastFiveDays.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    @IBAction func printWeather() {
        dump(currentWeather)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decodeCurrentWeaterFromAPI()

    }

}



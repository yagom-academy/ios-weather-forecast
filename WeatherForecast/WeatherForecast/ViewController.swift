//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    var currentWeather: CurrentWeather?
    
    func setElementValue() {
        guard let location: String = currentWeather?.location else { return }
        guard let currentTemp: Double = currentWeather?.temperature.currentTemperature else { return }
        guard let maxTemp: Double = currentWeather?.temperature.maximumTemperature else { return }
        guard let minTemp: Double = currentWeather?.temperature.minimumTemperature else { return }

        self.locationLabel.text = location
        self.currentTempLabel.text = String(currentTemp)
        self.maxTempLabel.text = String(maxTemp)
        self.minTempLabel.text = String(minTemp)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset.init(name: "CurrentWeather") else { return }

        do {
            self.currentWeather = try jsonDecoder.decode(CurrentWeather.self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        setElementValue()
    }
}


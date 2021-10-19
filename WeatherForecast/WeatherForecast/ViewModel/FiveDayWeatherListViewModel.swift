//
//  FiveDayWeatherViewModel.swift
//  WeatherForecast
//
//  Created by Soll on 2021/10/14.
//

import UIKit

class FiveDayWeatherListViewModel {
    
    var reloadTableView: (() -> Void)?
    var weatherService = WeatherService()
    var weathers: [FiveDayWeatherViewModel] = []
    
    var numberOfRowInSection: Int {
        return weathers.count
    }
}

struct FiveDayWeatherViewModel {
    
    var dateThreeHour: String
    var temperatureThreeHour: String
    var imageThreeHour: UIImage
    
    init(_ date: String, _ temperature: String, _ image: UIImage) {
        self.dateThreeHour = date
        self.temperatureThreeHour = temperature
        self.imageThreeHour = image
    }
}

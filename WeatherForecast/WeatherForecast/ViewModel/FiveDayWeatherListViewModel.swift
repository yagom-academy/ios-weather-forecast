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
    
    func mapFiveDayData() {
        weatherService.fetchByLocation { (fiveDayWeather: FiveDayWeatherData) in
            fiveDayWeather.intervalWeathers?.forEach({ data in
                guard let date = data.date?.format(),
                      let temperature = data.mainInformation?.temperature?.franctionDisits(),
                      let iconName = data.conditions?.first?.iconName,
                      let url: URL = URL(string: "https://openweathermap.org/img/w/\(iconName).png") else {
                    return
                }
                
                do {
                    let data = try Data(contentsOf: url)
                    guard let image = UIImage(data: data) else { return }
                    self.weathers.append(FiveDayWeatherViewModel(date, temperature, image))
                } catch {
                    print(error)
                }
            })
            self.reloadTableView?()
        }
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

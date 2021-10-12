//
//  WeatherInfoList.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import Foundation
import UIKit.UIImage
import CoreLocation.CLLocation

struct FiveDaysForecastData: Decodable {
    let lists: [ForcastInfomation]
    
    struct ForcastInfomation: Decodable {
        let date: Int
        let main: Temperature
        let weather: [WeatherDetail]
        
        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case main, weather
        }
        
        struct Temperature: Decodable {
            let temperature: Double
            
            enum CodingKeys: String, CodingKey {
                case temperature = "temp"
            }
        }
        
        struct WeatherDetail: Decodable {
            let icon: String
        }
    }
}



// MARK: - Model for tableView

class ForcastViewModel {
    private let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM, d"
        return dateFormatter
    }()
    
    private let tempFormatter: NumberFormatter = {
       let tempFormatter = NumberFormatter()
        tempFormatter.numberStyle = .none
        return tempFormatter
    }()
    
    func fetchWeatherData(location: (latitude: CLLocationDegrees, longitude: CLLocationDegrees), path: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/\(path)") else {
            return
        }
        let requestInfo: Parameters = ["lat": location.latitude , "lon": location.longitude, "appid": NetworkManager().openWeahterApiKey]
        
        let weatherApi = WeatherApi(httpTask: .request(withUrlParameters: requestInfo), httpMethod: .get, baseUrl: url)
        
        NetworkManager().fetchWeatherData(weatherAPI: weatherApi, URLSession.shared)
    }
    
}

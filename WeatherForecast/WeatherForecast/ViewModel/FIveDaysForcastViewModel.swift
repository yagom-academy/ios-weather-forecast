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
    var list: [ForcastInfomation]
}

struct ForcastInfomation: Decodable {
    var date: Int
    var main: Temperature
    var weather: [WeatherDetail]
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main, weather
    }
    
    struct Temperature: Decodable {
        var temperature: Double
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
        }
    }
    
    struct WeatherDetail: Decodable {
        var icon: String
    }
}

// MARK: - Model for tableView

protocol ViewModel: AnyObject {
    func buildApi(weatherOfCurrent: Path, location: (latitude: CLLocationDegrees, longitude: CLLocationDegrees)) -> OpenWeatherApi?
}

extension ViewModel {
    func buildApi(weatherOfCurrent: Path, location: (latitude: CLLocationDegrees, longitude: CLLocationDegrees)) -> OpenWeatherApi? {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5") else {
            return nil
        }
        
        let requestInfo: Parameters = ["lat": location.latitude , "lon": location.longitude, "appid": WeatherNetworkManager.apiKey]
        
        let api = OpenWeatherApi(httpTask: .request(withUrlParameters: requestInfo), httpMethod: .get, baseUrl: url, path: weatherOfCurrent)
        
        return api
    }
}

class ForcastViewModel: ViewModel {
    private let networkManager = WeatherNetworkManager()
    var location: Location?
    var forecast: FiveDaysForecastData?
    
    func fetchAndAssignForcastData() {
        guard let location = self.location,
              let api = buildApi(weatherOfCurrent: .forecast, location: location) else {
            return
        }
        
        networkManager.fetchData(requiredApi: api, URLSession.shared) { [weak self] result in
            
            guard let `self` = self else {
                return
            }
            self.forecast = result.forcast
        }
    }
    
    func listAtIndex(_ index: Int) -> ListViewModel? {
        guard let list = self.forecast?.list[index] else {
            return nil
        }
        
        return ListViewModel(list)
    }
}

class ListViewModel {
    private let list: ForcastInfomation
    
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
    
    //  MARK: - 뷰에 나타낼 요소들
    var date = Box(" ")
    var temperature = Box(" ")

    //var icon: Box<UIImage?> = Box(nil)
    
    init(_ list: ForcastInfomation) {
        self.list = list
        let date = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.list.date)))
        self.date.value = date
        self.temperature.value = "\(self.list.main.temperature)"
    }
}

//
//  APIURL.swift
//  WeatherForecast
//
//  Created by 김동빈 on 2021/01/23.
//

import Foundation
import CoreLocation

struct URLManager {
    enum APItype: String {
        case currentWeather = "weather?"
        case forecastFiveDays = "forecast?"
    }
    
    private let defaultURL = "https://api.openweathermap.org/data/2.5/"
    private let apiID = "f08f782b840c2494b77e036d6bf2f3de"

    func makeURL(APItype: APItype, location: CLLocation) -> URL? {
        var url = URLComponents(string: defaultURL + APItype.rawValue)
        let latitude = URLQueryItem(name: "lat", value: String(location.coordinate.latitude))
        let longitude = URLQueryItem(name: "lon", value: String(location.coordinate.longitude))
        let ID = URLQueryItem(name: "appid", value: apiID)
        
        url?.queryItems = [latitude, longitude, ID]
        
        return url?.url
    }
}

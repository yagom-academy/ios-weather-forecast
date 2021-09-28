//
//  CurrentWeatherAPI.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/09/28.
//

import Foundation

struct CurrentWeatherAPI: APIable, WeatherAPIable {
    var requestType: RequestType = .get
    var url: URL?
    var parameter: [String : Any]?
    var callType: CallType
    let baseURL = "api.openweathermap.org/data/2.5/weather"
    let apiKey: String = ""
    
    init(callType: CallType) {
        var components = URLComponents(string: baseURL)
        var queryItems = [URLQueryItem]()
        
        switch callType {
        case .ZIPCode(let zipCode, let parameter):
            queryItems.append(URLQueryItem(name: "zip", value: zipCode.description))
            queryItems.append(contentsOf: parameter?.generateURLQueryItems() ?? [])
            components?.queryItems = queryItems
        case .cityID(let cityID, let parameter):
            queryItems.append(URLQueryItem(name: "id", value: cityID.description))
            queryItems.append(contentsOf: parameter?.generateURLQueryItems() ?? [])
            components?.queryItems = queryItems
        case .cityName(let cityName, let parameter):
            queryItems.append(URLQueryItem(name: "q", value: cityName))
            queryItems.append(contentsOf: parameter?.generateURLQueryItems() ?? [])
            components?.queryItems = queryItems
        case .geographicCoordinates(let coordinate, let parameter):
            queryItems.append(URLQueryItem(name: "lat", value: coordinate.latitude.description))
            queryItems.append(URLQueryItem(name: "lon", value: coordinate.longitude.description))
            queryItems.append(contentsOf: parameter?.generateURLQueryItems() ?? [])
            components?.queryItems = queryItems
        }
        self.url = components?.url
        self.callType = callType
    }
}

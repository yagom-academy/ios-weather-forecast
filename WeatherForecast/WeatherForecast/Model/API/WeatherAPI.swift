//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/09/28.
//

import Foundation

struct WeatherAPI: WeatherAPIable {
    var requestType: RequestType = .get
    var url: URL?
    var parameter: [String : Any]?
    var callType: CallType
    var forecastType: ForecastType
    private let apiKey: String = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    var contentType: ContentType?

    
    init(callType: CallType, forecastType: ForecastType) {
        var components = URLComponents(string: forecastType.baseURL)
        var queryItems = generateQueryItems(from: callType)
        
        queryItems.append(URLQueryItem(name: "appid", value: apiKey))
        components?.queryItems = queryItems
        
        self.url = components?.url
        self.callType = callType
        self.forecastType = forecastType
    }
    
    private func generateQueryItems(from callType: CallType) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        
        switch callType {
        case .ZIPCode(let zipCode, let parameter):
            queryItems.append(URLQueryItem(name: "zip", value: zipCode.description))
            queryItems.append(contentsOf: parameter?.generateURLQueryItems() ?? [])
        case .cityID(let cityID, let parameter):
            queryItems.append(URLQueryItem(name: "id", value: cityID.description))
            queryItems.append(contentsOf: parameter?.generateURLQueryItems() ?? [])
        case .cityName(let cityName, let parameter):
            queryItems.append(URLQueryItem(name: "q", value: cityName))
            queryItems.append(contentsOf: parameter?.generateURLQueryItems() ?? [])
        case .geographicCoordinates(let coordinate, let parameter):
            queryItems.append(URLQueryItem(name: "lat", value: coordinate.latitude.description))
            queryItems.append(URLQueryItem(name: "lon", value: coordinate.longitude.description))
            queryItems.append(contentsOf: parameter?.generateURLQueryItems() ?? [])
        }
        
        return queryItems
    }
}

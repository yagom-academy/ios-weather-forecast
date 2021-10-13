//
//  WeatherInfoList.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import Foundation
import CoreLocation.CLLocationManager

protocol ApiModeling: AnyObject {
    func buildApi(weatherOfCurrent: URLPath, location: (latitude: CLLocationDegrees, longitude: CLLocationDegrees)) -> OpenWeatherApi?
}

extension ApiModeling {
    func buildApi(weatherOfCurrent: URLPath, location: (latitude: CLLocationDegrees, longitude: CLLocationDegrees)) -> OpenWeatherApi? {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5") else {
            return nil
        }

        let requestInfo: Parameters = ["lat": location.latitude , "lon": location.longitude, "appid": WeatherNetworkManager.apiKey]

        let api = OpenWeatherApi(httpTask: .request(withUrlParameters: requestInfo), httpMethod: .get, baseUrl: url, path: weatherOfCurrent)

        return api
    }
}


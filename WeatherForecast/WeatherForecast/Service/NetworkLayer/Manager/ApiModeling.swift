//
//  WeatherInfoList.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import Foundation
import CoreLocation.CLLocationManager

protocol ApiModeling: AnyObject {
    func buildApi(weatherOrCurrent: URLPath, location: (latitude: CLLocationDegrees, longitude: CLLocationDegrees)) -> OpenWeatherAPI?
}

extension ApiModeling {
    func buildApi(weatherOrCurrent: URLPath, location: (latitude: CLLocationDegrees, longitude: CLLocationDegrees)) -> OpenWeatherAPI? {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5") else {
            return nil
        }

        let requestInfo: QueryItems = ["lat": location.latitude , "lon": location.longitude, "appid": WeatherNetworkManager.apiKey]

        let api = OpenWeatherAPI(httpTask: .request(withUrlParameters: requestInfo), httpMethod: .get, baseUrl: url, path: weatherOrCurrent)

        return api
    }
}


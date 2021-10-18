//
//  OpenWeatherTableViewDelegate.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/15.
//

import UIKit
import CoreLocation.CLLocationManager


class WeatherTableViewDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: OpenWeatherHeaderView.identifier) as? OpenWeatherHeaderView else {
            return UIView()
        }
        
        guard let weatherData = WeatherDataHolder.shared.current else {
            return UIView()
        }
 
        let iconID = weatherData.weather.first?.icon
        let date = weatherData.date
        
        let urlString = "https://openweathermap.org/img/w/\(iconID ?? "").png"

        ImageLoader.downloadImage(reqeustURL: urlString, imageCachingKey: date) { requestedIcon in
            DispatchQueue.main.async {
                view.configureIconImage(requestedIcon)
            }
        }

        let currentLocation = CLLocation(latitude: weatherData.coordination.lattitude, longitude: weatherData.coordination.longitude)
        let locale = Locale(identifier: "ko")
        
        CLGeocoder().reverseGeocodeLocation(currentLocation, preferredLocale: locale) { placeMarks, error in
            guard error == nil else {
                return
            }
            
            guard let addresses = placeMarks,
                  let currentAddress = addresses.last?.name else {
                return
            }
            view.confifureAddress(currentAddress)
        }
        
        view.configureDateAndTemperature()
        
        return view
    }
}

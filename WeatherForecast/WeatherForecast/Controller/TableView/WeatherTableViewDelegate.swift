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
                view.configureIcon(requestedIcon)
            }
        }
        
        return view
    }
}

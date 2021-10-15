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
        
              
        view.configure()
        
      
        return view
    }
    
}

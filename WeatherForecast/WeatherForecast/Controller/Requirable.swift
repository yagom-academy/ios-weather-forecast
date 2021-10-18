//
//  Requirable.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/18.
//

import UIKit

protocol Requirable: NSObject {
    func requireUserLocation()
    func reloadWeatherData(_ refreshControl: UIRefreshControl?)
}

extension Requirable where Self: UITableViewController {
    
}

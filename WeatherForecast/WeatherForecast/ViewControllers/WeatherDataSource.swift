//
//  WeatherDataSource.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/22.
//

import UIKit

class WeatherDataSource: NSObject, UITableViewDataSource {
    private var fiveDaysWeatherList: [List] = [] {
        didSet {
            DispatchQueue.main.async {
                self.dataDidUpdated?()
            }
        }
    }
    
    var dataDidUpdated: (() -> Void)?
    
    func updateDataSource(on fiveDaysWeatherList: [List]) {
        self.fiveDaysWeatherList = fiveDaysWeatherList
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDaysWeatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(on: fiveDaysWeatherList[indexPath.row])
        
        return cell
    }
}

//
//  MainWeatherTableViewDataSource.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/10/11.
//

import UIKit

final class MainWeatherTableViewDataSource: NSObject {
    private var fiveDayWeatherList: [WeatherForOneDay] = []
    
}

extension MainWeatherTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDayWeatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainWeatherTableViewCell.identifier, for: indexPath) as? MainWeatherTableViewCell else {
            return UITableViewCell()
        }
        let weather = fiveDayWeatherList[indexPath.row]
        cell.configure(data: weather)
        
        return cell
    }
    
    
}

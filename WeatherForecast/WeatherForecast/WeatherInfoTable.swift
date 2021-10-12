//
//  WeatherTable.swift
//  WeatherForecast
//
//  Created by 오승기 on 2021/10/11.
//

import UIKit

class WeatherInfoTable: NSObject, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherInfo.identifier, for: indexPath) as? HourlyWeatherInfo else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "1"
        return cell
    }
}

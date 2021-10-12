//
//  WeatherForecastViewDataSource.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/13.
//

import UIKit

class WeatherForecastViewDataSource: NSObject, UITableViewDataSource {
    var currentWeatherData: CurrentWeather?
    var forecastWeatherData: ForecastWeather?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastWeatherData?.list.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastViewCell.identifier,
                                                       for: indexPath) as? WeatherForecastViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}

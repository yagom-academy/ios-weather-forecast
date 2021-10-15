//
//  WeatherTableViewDataSource.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import UIKit

class WeatherTableviewDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherDataHolder.shared.forcast?.list.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? FiveDaysForecastCell else {
            return UITableViewCell()
        }
        
        guard let list = WeatherDataHolder.shared.forcast?.list[indexPath.row] else {
            return UITableViewCell()
        }

        var image = UIImage()
        let urlString = "https://openweathermap.org/img/w/\(list.weather.first?.icon ?? "").png"
        
        ImageLoader.downloadImage(reqeustURL: urlString, imageCachingKey: list.date) { requestedIcon in
            image = requestedIcon
            DispatchQueue.main.async {
                cell.configure(image)
            }
        }
        
        let cellHolder = CellHolder(forcastInformation: list)
        
        cell.configure(cellHolder)
        
        return cell
    }
}

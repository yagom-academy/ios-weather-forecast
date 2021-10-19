//
//  MainWeatherTableViewDataSource.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/10/11.
//

import UIKit

final class MainWeatherTableViewDataSource: NSObject {
    var fiveDayWeatherList: [WeatherForOneDay] = []
}

extension MainWeatherTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDayWeatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainWeatherTableViewCell.self), for: indexPath) as? MainWeatherTableViewCell else {
            return UITableViewCell()
        }
        cell.resetAllContents()
        let weather = fiveDayWeatherList[indexPath.row]
        cell.configure(data: weather)
        cell.iconId = weather.weatherConditionCodes?.last?.iconId
        if let imageId = cell.iconId {
            let imageAPI = ImageAPI(imageId: imageId)
            
            NetworkManager.imageRequest(using: imageAPI) { result in
                guard cell.iconId == imageId else {
                    return
                }
                DispatchQueue.main.async {
                    switch result {
                    case .failure(_):
                        break
                    case .success(let image):
                        cell.configure(image: image)
                    }
                }
            }
        }
        return cell
    }
    
    
}

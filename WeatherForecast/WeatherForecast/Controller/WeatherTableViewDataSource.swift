//
//  WeatherTableViewDataSource.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import UIKit

class WeatherTableviewDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? FiveDaysForcecastCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}

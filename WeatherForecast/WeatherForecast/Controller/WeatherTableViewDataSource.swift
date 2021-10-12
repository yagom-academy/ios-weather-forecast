//
//  WeatherTableViewDataSource.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import UIKit

class WeatherTableviewDataSource: NSObject, UITableViewDataSource {
    var vm: ForcastViewModel?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.forecast?.list.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? FiveDaysForcecastCell else {
            return UITableViewCell()
        }
        
        let list = vm?.listAtIndex(indexPath.row)
        let holder = CellHolder(dateLabelText: list?.date.value, temperatureText: list?.temperature.value, iconImage: UIImage(named: "cat")!)
        
        cell.configure(holder)
        
        return cell
    }
}

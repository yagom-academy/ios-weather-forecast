//
//  WeatherTableViewDataSource.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import UIKit

class WeatherTableviewDataSource: NSObject, UITableViewDataSource {

    // 데이터 디코딩해서 할당하기
    //var vm: FiveDaysForecastViewModel?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm?.numberOfRowsInSection() ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? FiveDaysForcecastCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}

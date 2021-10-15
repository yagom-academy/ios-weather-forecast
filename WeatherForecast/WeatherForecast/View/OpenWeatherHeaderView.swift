//
//  OpenWeatherHeaderView.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/15.
//

import UIKit

class OpenWeatherHeaderView: UITableViewHeaderFooterView {
    private let addressLabel = UILabel()
    private let maxTemperatureLabel = UILabel()
    private let minTemperatureLabel = UILabel()
    private let nowTemperatureLabel = UILabel()
    private let iconImage = UIImage()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        positionContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OpenWeatherHeaderView {
    func positionContents() {
        
    }
}

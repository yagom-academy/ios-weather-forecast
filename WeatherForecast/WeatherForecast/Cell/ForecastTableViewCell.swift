//
//  ForecastTableViewCell.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/22.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    private let temperatureSign = "°"

    // MARK: - init func
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  WeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/19.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    static let identifier = "WeatherCell"
    
    private let dataLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherIconImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(on fiveDaysWeatherItem: List) {
        
    }
}

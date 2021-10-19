//
//  WeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/19.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    static let identifier = "WeatherCell"
    
    private let dateLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherIconImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        updateCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Cell Data
extension WeatherTableViewCell {
    func configure(on fiveDaysWeatherItem: List) {
        dateLabel.text = parseDateInfo(on: fiveDaysWeatherItem.dtTxt)
        temperatureLabel.text = convertToCelsius(on: fiveDaysWeatherItem.main?.temp)
        updateWeatherIcon(to: fiveDaysWeatherItem.weather?[0].icon)
    }
    
    private func convertString2DateType(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.date(from: string)
    }
    
    private func convertDateType2String(_ date: Date?) -> String {
        guard let date = date else {
            return "-"
        }
        
        let dateFommatter = DateFormatter()
        dateFommatter.locale = Locale(identifier: "ko_KR")
        dateFommatter.timeZone = TimeZone(abbreviation: "KST")
        dateFommatter.dateFormat = "MM/dd (E) HH시"
        
        return dateFommatter.string(from: date)
    }
    
    private func parseDateInfo(on dateText: String?) -> String {
        guard let dateText = dateText else {
            return " "
        }
        let dateType = convertString2DateType(dateText)
        return convertDateType2String(dateType)
    }
    
    private func convertToCelsius(on fahrenheit: Double?) -> String {
        guard let fahrenheit = fahrenheit else {
            return " "
        }
        return "\(String(format: "%.2f", fahrenheit - 273.15)) ℃"
    }
    
    private func updateWeatherIcon(to iconID: String?) {
        // TODOs : 아이콘에 따른 이미지 처리.
    }
}

// MARK: - Update Cell Layout
extension WeatherTableViewCell {
    private func updateCellLayout() {
        updateDateLabelLayout()
        updateWeatherIconImageViewLayout()
        updateTemperatureLabelLayout()
    }
    
    private func prepareForLayout(with view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
    }
    
    private func updateDateLabelLayout() {
        prepareForLayout(with: dateLabel)
        
        dateLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 10
        ).isActive = true
        
        dateLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: 10
        ).isActive = true
        
        dateLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -10
        ).isActive = true
    }
    
    private func updateWeatherIconImageViewLayout() {
        prepareForLayout(with: weatherIconImageView)
     
        weatherIconImageView.widthAnchor.constraint(
            equalToConstant: 30
        ).isActive = true
        
        weatherIconImageView.heightAnchor.constraint(
            equalToConstant: 30
        ).isActive = true
        
        weatherIconImageView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -10
        ).isActive = true
        
        weatherIconImageView.centerYAnchor.constraint(
            equalTo: contentView.centerYAnchor
        ).isActive = true
        
        weatherIconImageView.backgroundColor = .orange
    }
    
    private func updateTemperatureLabelLayout() {
        prepareForLayout(with: temperatureLabel)
        
        temperatureLabel.trailingAnchor.constraint(
            equalTo: weatherIconImageView.leadingAnchor,
            constant: -10
        ).isActive = true
        
        temperatureLabel.centerYAnchor.constraint(
            equalTo: contentView.centerYAnchor
        ).isActive = true
    }
}

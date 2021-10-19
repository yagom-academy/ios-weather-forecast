//
//  FiveDaysForcecastCell.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import UIKit

extension DateFormatter {
    static func customDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko")
        formatter.setLocalizedDateFormatFromTemplate("MM/dd(E) HH시")
        
        return formatter
    }
}

extension NumberFormatter {
    static func customTemperatureFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .decimal
        return formatter
    }
}

class CellHolder {
    private let dateLabelText: String
    private let temperatureText: String
    
    init(forcastInformation: ForcastInfomation) {
        let dateformatter = DateFormatter.customDateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(forcastInformation.date))
        let formattedDate = dateformatter.string(from: date)
        self.dateLabelText = formattedDate

        let formattedTemperature = TemperatureConverter(celciusTemperature: forcastInformation.main.temperature).convertedTemperature
        self.temperatureText = "\(formattedTemperature)°"
    }
    
    var date: String {
        return self.dateLabelText
    }
    
    var temperature: String {
        return self.temperatureText
    }
}

class FiveDaysForecastCell: UITableViewCell {
    static let identifier = "weatherCell"
    
    func configure(_ holder: CellHolder) {
        self.dateLabel.text = holder.date
        self.temperatureLabel.text = holder.temperature
    }
    
    func configure(_ iconImgae: UIImage) {
        self.weatherIconImageView.image = iconImgae
    }
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = .black
        return dateLabel
    }()
    
    private let temperatureLabel: UILabel = {
        let temLabel = UILabel()
        temLabel.textColor = .black
        return temLabel
    }()
    
    private let weatherIconImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        positionUIElements()
        setLabelStyle()
        self.backgroundView?.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FiveDaysForecastCell {
    private func setLabelStyle() {
        self.setDynamicType(to: dateLabel, .body)
        self.setDynamicType(to: temperatureLabel, .body)
        self.dateLabel.textAlignment = .center
        self.temperatureLabel.textAlignment = .center
    }
    
    private func setDynamicType(to label: UILabel, _ font: UIFont.TextStyle) {
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: font)
    }
    
    private func positionUIElements() {
        self.contentView.addSubview(self.dateLabel)
        self.dateLabel.setPosition(top: self.contentView.topAnchor,
                                   bottom:  self.contentView.bottomAnchor,
                                   leading: self.contentView.leadingAnchor,
                                   leadingConstant: 20,
                                   trailing: nil)
        
        self.contentView.addSubview(self.temperatureLabel)
        self.temperatureLabel.setPosition(top: self.contentView.topAnchor,
                                          bottom:  self.contentView.bottomAnchor,
                                          leading: self.dateLabel.leadingAnchor,
                                          leadingConstant: 290,
                                          trailing: nil)
        
        self.contentView.addSubview(self.weatherIconImageView)
        
        self.weatherIconImageView.setPosition(top: self.contentView.topAnchor,
                                              bottom:  self.contentView.bottomAnchor,
                                              leading: nil,
                                              trailing: self.contentView.trailingAnchor,
                                              trailingConstant: -20)
    }
}

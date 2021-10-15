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
        formatter.locale = Locale(identifier: "Ko-kr")
        formatter.setLocalizedDateFormatFromTemplate("MM.dd E hh시")
        
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
        
        let celsiusUnit = UnitTemperature.celsius
        let convertedTemperature = celsiusUnit.converter.value(fromBaseUnitValue: forcastInformation.main.temperature)
        let formattedTemperature = NumberFormatter.customTemperatureFormatter().string(for: convertedTemperature)!
        self.temperatureText = "\(formattedTemperature)℃"
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
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        self.contentView.addSubview(dateLabel)
        dateLabel.setPosition(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil)
        dateLabel.textColor = .black
        dateLabel.textAlignment = .center
        
        return dateLabel
    }()
    
    private var temperatureLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.textColor = .black
        tempLabel.textAlignment = .center
        
        return tempLabel
    }()
    
    private lazy var weatherIconImageView: UIImageView = {
        let weatherIcon = UIImageView()
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        weatherIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return UIImageView()
    }()
    
    private var stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        drawStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func drawStackView() {
        stackView = UIStackView(arrangedSubviews: [temperatureLabel, weatherIconImageView])
        self.contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.setPosition(top: self.contentView.topAnchor, bottom: self.contentView.bottomAnchor, leading: self.contentView.leadingAnchor, leadingConstant: 250, trailing: self.contentView.trailingAnchor)
        
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 5
        
        setLabelStyle()
    }
    
    private func setLabelStyle() {
        self.setDynamicType(dateLabel, .body)
        self.setDynamicType(temperatureLabel, .body)
        self.dateLabel.textAlignment = .center
        self.temperatureLabel.textAlignment = .center
    }
    
    private func setDynamicType(_ label: UILabel, _ font: UIFont.TextStyle) {
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: font)
    }
}

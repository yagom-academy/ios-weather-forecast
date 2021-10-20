//
//  FiveDaysForcecastCell.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import UIKit

final class FiveDaysForecastCell: UITableViewCell {
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
    
    private var weatherIconImageView = UIImageView()
    
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
    
    override func prepareForReuse() {
        self.dateLabel.text = "--"
        self.temperatureLabel.text = "--"
        self.weatherIconImageView.image = nil
    }
}

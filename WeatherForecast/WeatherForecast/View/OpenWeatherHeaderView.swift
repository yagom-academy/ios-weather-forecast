//
//  OpenWeatherHeaderView.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/15.
//

import UIKit
import CoreLocation.CLLocationManager

extension CLGeocoder {
    func makeAddress() -> String {
        guard let coordination = WeatherDataHolder.shared.current?.coordination else {
            return "야곰시 야곰동"
        }
        let location2 = CLLocation(latitude: coordination.lattitude, longitude: coordination.longitude)
        
        let locale = Locale(identifier: "Ko-kr")
        var address = ""
        self.reverseGeocodeLocation(location2, preferredLocale: locale) { placeMarks, error in
            guard error == nil else {
                return
            }
            
            guard let addresses = placeMarks,
                  let currentAddress = addresses.last?.name else {
                return
            }
            address = currentAddress
        }
        return address
    }
}

class OpenWeatherHeaderView: UITableViewHeaderFooterView {
    static let identifier = "weatherHeaderView"
    
    private let addressLabel = UILabel()
    private let minMaxTemperature = UILabel()
    private let currentTemperatureLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        positionContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let currentWeatherData = WeatherDataHolder.shared.current else {
            print("\(#function)에 들어갈 데이터가 없습니다.")
            return
        }
        
        let maxTem = currentWeatherData.main.temperatureMaximum
        let minTem = currentWeatherData.main.temperatureMinimum
        let address = CLGeocoder().makeAddress()
        let currentTem = currentWeatherData.main.currentTemperature
        
        let convertedCurentTem = TemperatureConverter(celciusTemperature: currentTem).convertedTemperature
        let convertedmaxTem = TemperatureConverter(celciusTemperature: maxTem).convertedTemperature
        let convertedminTem = TemperatureConverter(celciusTemperature: minTem).convertedTemperature
        
        self.addressLabel.text = address
        self.minMaxTemperature.text = "최고 \(convertedmaxTem)° 최저 \(convertedminTem)°"
        self.currentTemperatureLabel.text = "\(convertedCurentTem)"
    }
    
    func configureIcon(_ image: UIImage) {
        self.iconImageView.image = image
        self.iconImageView.contentMode = .scaleAspectFit
    }
}

extension OpenWeatherHeaderView {
    private func positionContents() {
        self.contentView.addSubview(self.iconImageView)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.iconImageView.setPosition(top: self.contentView.topAnchor,
                                       bottom: self.contentView.bottomAnchor,
                                       leading: self.contentView.leadingAnchor,
                                       trailing: self.contentView.trailingAnchor)
        
    }
}

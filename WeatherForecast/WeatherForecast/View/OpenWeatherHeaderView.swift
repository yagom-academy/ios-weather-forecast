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
    private let maxTemperatureLabel = UILabel()
    private let minTemperatureLabel = UILabel()
    private let nowTemperatureLabel = UILabel()
    private var iconImage = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        positionContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OpenWeatherHeaderView {
    private func positionContents() {
        
    }
    
    func configure() {
        let currentWeatherData = WeatherDataHolder.shared.current
        let maxTem = currentWeatherData?.main.temperatureMaximum
        let minTem = currentWeatherData?.main.temperatureMaximum
        let address = CLGeocoder().makeAddress()
        let iconID = currentWeatherData?.weather.first?.icon
        
        self.addressLabel.text = address
        self.maxTemperatureLabel.text = "\(maxTem)"
        
      
    }
    
    func configureIcon(_ image: UIImage) {
        self.iconImage.image = image
    }
}

//
//  WeatherHeaderView.swift
//  WeatherForecast
//
//  Created by 오승기 on 2021/10/12.
//

import UIKit
import CoreLocation

class WeatherHeaderView: UITableViewHeaderFooterView {

    static let identifier = "WeatherHeaderView"
    private lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textColor = .white
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        return locationLabel
    }()
    
    private lazy var minMaxTemperatureLabel: UILabel = {
        let minMaxTemperatureLabel = UILabel()
        minMaxTemperatureLabel.textColor = .white
        minMaxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        return minMaxTemperatureLabel
    }()
    
    private lazy var currentTemperatureLabel: UILabel = {
        let currentTemperatureLabel = UILabel()
        currentTemperatureLabel.textColor = .white
        currentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTemperatureLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return currentTemperatureLabel
    }()
    
    private lazy var weatherImage: UIImageView = {
        let weatherImage = UIImageView()
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.contentMode = .scaleToFill
        return weatherImage
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContents() {
        contentView.addSubview(weatherImage)
        contentView.addSubview(locationLabel)
        contentView.addSubview(minMaxTemperatureLabel)
        contentView.addSubview(currentTemperatureLabel)
        
        NSLayoutConstraint.activate([weatherImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                                     weatherImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -20),
                                     weatherImage.widthAnchor.constraint(equalToConstant: 70),
                                     weatherImage.heightAnchor.constraint(equalToConstant: 70),
                                     locationLabel.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 10),
                                     locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -20),
                                     minMaxTemperatureLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
                                     minMaxTemperatureLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
                                     currentTemperatureLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
                                     currentTemperatureLabel.topAnchor.constraint(equalTo: minMaxTemperatureLabel.bottomAnchor, constant: 10)])
    }
    
    func setUpUI(currentWeather: CurrentWeather?, placemark: [CLPlacemark]?) {
        if let icon = currentWeather?.weather.first?.icon {
            let imageURL = String(format: "https://openweathermap.org/img/w/%@.png", icon)
            weatherImage.downloadImage(from: imageURL)
        }
        guard let currentWeather = currentWeather else {
            return
        }
        
        if let placemark = placemark?.first {
            locationLabel.text = String(placemark.administrativeArea ?? "")
            + String(placemark.locality ?? "")
        }
        minMaxTemperatureLabel.text = changeToCelcius(minimum: currentWeather.main.tempMin,
                                                      maximum: currentWeather.main.tempMax)
        currentTemperatureLabel.text = changeToCelcius(to: currentWeather.main.temp)
    }
}

extension UIImageView {
    func downloadImage(from link: String) {
        guard let url = URL(string: link) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                if let data = data {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}

extension WeatherHeaderView {
    func changeToCelcius(to kelvin: Double) -> String {
        return String(format: "%.1f°", kelvin - 273.15)
    }
    
    func changeToCelcius(minimum: Double, maximum: Double) -> String {
        let minimumCelcius = minimum - 273.15
        let maximumCelcius = maximum - 273.15
        return String(format: "최저 %.1f° 최고 %.1f°", minimumCelcius, maximumCelcius)
    }
}

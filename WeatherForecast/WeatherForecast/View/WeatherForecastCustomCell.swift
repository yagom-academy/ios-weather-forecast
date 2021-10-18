//
//  WeatherForecastCustomCell.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/12.
//

import UIKit

class WeatherForecastCustomCell: UICollectionViewCell {
    static let identifier = "fiveDay"
    var urlString: String?
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        dateLabel.textColor = .systemGray
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.text = Placeholder.date.text
        return dateLabel
    }()
    
    let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        temperatureLabel.textColor = .systemGray
        temperatureLabel.adjustsFontForContentSizeCategory = true
        return temperatureLabel
    }()
    
    let weatherImage: UIImageView = {
        let weatherImage = UIImageView()
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.widthAnchor.constraint(equalTo: weatherImage.heightAnchor).isActive = true
        weatherImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return weatherImage
    }()
    
    lazy var horizontalStackView: UIStackView = {
        var horizontalStackView = UIStackView(arrangedSubviews: [dateLabel, temperatureLabel, weatherImage])
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fill
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.spacing = 10
        horizontalStackView.axis = .horizontal
        contentView.addSubview(horizontalStackView)
        return horizontalStackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        backgroundView?.backgroundColor = UIColor.clear
        backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
        setLayoutForStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayoutForStackView() {
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(image: UIImage?) {
        if let image = image {
            weatherImage.image = image
        }
    }
    
    func configure(date: Int, temparature: Double) {
        resetContents()
        
        dateLabel.text = format(date: date)
        temperatureLabel.text = TemperatureManager.convert(kelvinValue: temparature,
                                                           to: .celsius,
                                                           fractionalCount: 1)
    }
    
    func resetContents() {
        dateLabel.text = nil
        temperatureLabel.text = nil
        weatherImage.image = nil
    }
    
    func format(date: Int) -> String? {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        return dateFormatter.string(from: date)
    }
}

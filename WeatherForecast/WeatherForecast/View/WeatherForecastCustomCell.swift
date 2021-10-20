//
//  WeatherForecastCustomCell.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/12.
//

import UIKit

final class WeatherForecastCustomCell: UICollectionViewCell {
    static let identifier = "fiveDay"
    var urlString: String?
    
    private let dateLabel = UILabel.makeLabel(font: .body, text: Placeholder.date.text)
    private let temperatureLabel = UILabel.makeLabel(font: .body)
    
    private let weatherImage: UIImageView = {
        let weatherImage = UIImageView()
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.widthAnchor.constraint(equalTo: weatherImage.heightAnchor).isActive = true
        weatherImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        return weatherImage
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        var horizontalStackView = UIStackView(arrangedSubviews: [dateLabel, temperatureLabel, weatherImage])
        temperatureLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fill
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        contentView.addSubview(horizontalStackView)
        return horizontalStackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForStackView() {
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
    
    private func resetContents() {
        dateLabel.text = nil
        temperatureLabel.text = nil
        weatherImage.image = nil
    }
    
    private func format(date: Int) -> String? {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        return dateFormatter.string(from: date)
    }
}

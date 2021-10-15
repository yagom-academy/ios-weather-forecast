//
//  CustomHeaderView.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/14.
//

import UIKit

enum AlertResource: String {
    case alertTitle = "위치 변경"
    case alertMessage = "변경할 좌표를 선택해 주세요"
    case changeButton = "변경"
    case resetCurrentCoordinateButton = "현재 위치로 재설정"
    case cancelButton = "취소"
}

class CustomHeaderView: UITableViewHeaderFooterView {
    static let identifier = "headerView"
    
    var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var mininumAndMaximumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    var coordinateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("위치 설정", for: .normal)
        button.setTitleColor(.white, for: .normal)
//        button.isUserInteractionEnabled = true
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHeaderView()
        addTargetCoordinateButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomHeaderView {
    private func addTargetCoordinateButton() {
        coordinateButton.addTarget(self, action: #selector(coordinateButtonAction), for: .touchUpInside)
    }
    
    @objc private func coordinateButtonAction() {
        NotificationCenter.default.post(name: NSNotification.Name("alert"), object: nil)
    }
    
    func configurationHeaderView(address: String, minMaxTemperature: String, currentTemperature: String, image: UIImage? = nil) {
        self.addressLabel.text = address
        self.currentTemperatureLabel.text = currentTemperature
        self.mininumAndMaximumTemperatureLabel.text = minMaxTemperature
        self.weatherImageView.image = UIImage(named: "background")
    }
    
    func setupHeaderView() {
        verticalStackView.addArrangedSubview(addressLabel)
        verticalStackView.addArrangedSubview(mininumAndMaximumTemperatureLabel)
        verticalStackView.addArrangedSubview(currentTemperatureLabel)
        
        contentView.addSubview(weatherImageView)
        contentView.addSubview(verticalStackView)
        contentView.addSubview(coordinateButton)
        
        NSLayoutConstraint.activate([
            weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            weatherImageView.widthAnchor.constraint(equalToConstant: 100),
            weatherImageView.heightAnchor.constraint(equalTo: weatherImageView.widthAnchor),
            weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            verticalStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 5),
            verticalStackView.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 10),
            verticalStackView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -5),
            verticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            verticalStackView.trailingAnchor.constraint(greaterThanOrEqualTo: coordinateButton.leadingAnchor, constant: 20),
            
            coordinateButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant:-5),
            coordinateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}

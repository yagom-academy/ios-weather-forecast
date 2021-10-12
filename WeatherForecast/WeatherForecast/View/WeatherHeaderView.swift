//
//  WeatherHeaderView.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/11.
//

import UIKit

class WeatherHeaderView: UIView {
    
    enum NameSpace {
        static let minTempatureDescription = "최저"
        static let maxPempatureDescription = "최고"
        static let tempatureStackViewSpacing: CGFloat = 8
        static let containerStackViewSpacing: CGFloat = 8
    }
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        return label
    }()
    
    private let minTempatureDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = NameSpace.minTempatureDescription
        label.textColor = .white
        return label
    }()
    
    private let minTempatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        return label
    }()
    
    private let maxTempatureDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = NameSpace.maxPempatureDescription
        label.textColor = .white
        return label
    }()
    
    private let maxTempatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        return label
    }()
    
    private let currentTempatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.textColor = .white
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let tempatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = NameSpace.tempatureStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = NameSpace.containerStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentsLayout()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeatherHeaderView {
    private func configureContentsLayout() {
        tempatureStackView.addArrangedSubview(minTempatureDescriptionLabel)
        tempatureStackView.addArrangedSubview(minTempatureLabel)
        tempatureStackView.addArrangedSubview(maxTempatureDescriptionLabel)
        tempatureStackView.addArrangedSubview(maxTempatureLabel)
        
        containerStackView.addArrangedSubview(addressLabel)
        containerStackView.addArrangedSubview(tempatureStackView)
        containerStackView.addArrangedSubview(currentTempatureLabel)
        
        addSubview(weatherImageView)
        addSubview(containerStackView)
        
        let imageViewWidthSize: CGFloat = 50
        let imageViewHeightSize: CGFloat = 50
        let imageViewCenterYConstant: CGFloat = 60
        let imageViewleadingConstant: CGFloat = 8
        let stackViewCenterYConstant: CGFloat = 60
        let stackViewTrailingConstant: CGFloat = 8
        
        NSLayoutConstraint.activate([
            weatherImageView.widthAnchor.constraint(equalToConstant: imageViewWidthSize),
            weatherImageView.heightAnchor.constraint(equalToConstant: imageViewHeightSize),
            weatherImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: imageViewCenterYConstant),
            weatherImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: imageViewleadingConstant),
            
            containerStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: stackViewCenterYConstant),
            containerStackView.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: stackViewTrailingConstant)
        ])
    }
    
    func configureContents(address: String,
                           minTempature: String,
                           maxTempature: String,
                           currentTempature: String,
                           weatherImage: UIImage?) {
        self.addressLabel.text = address
        self.minTempatureLabel.text = minTempature
        self.maxTempatureLabel.text = maxTempature
        self.currentTempatureLabel.text = currentTempature
        self.weatherImageView.image = weatherImage
    }
}

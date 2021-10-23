//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/14.
//

import Foundation

final class WeatherHeaderViewModel {
    private let service = WeatherService()
    
    var onCompleted: (() -> Void)?
    
    var address: String? {
        didSet {
            onCompleted?()
        }
    }
    var minTempature: String? {
        didSet {
            onCompleted?()
        }
    }
    var maxTempature: String? {
        didSet {
            onCompleted?()
        }
    }
    var iconData: Data? {
        didSet {
            onCompleted?()
        }
    }
    var currentTempature: String? {
        didSet {
            onCompleted?()
        }
    }
    
    init() {
        configureContents()
        service.onCompleted = { [weak self] in
            guard let self = self else { return }
            self.iconData = self.service.currentImageData
            self.configureContents()
        }
    }
    
    private func configureContents() {
        address = service.getAddress()
        
        let tempatures = service.currentWeatherTempature()
        minTempature = formattingTempature(tempatures.min)
        maxTempature = formattingTempature(tempatures.max)
        currentTempature = formattingTempature(tempatures.current)
    }
    
    private func formattingTempature(_ tempature: Double?) -> String? {
        guard let tempature = tempature else {
            return nil
        }
        
        let numberFormat = NumberFormatter()
        let minInterDigits = 1
        let minFractionDigits = 1
        let maxFractionDigits = 1
        
        numberFormat.roundingMode = .floor
        numberFormat.minimumIntegerDigits = minInterDigits
        numberFormat.minimumFractionDigits = minFractionDigits
        numberFormat.maximumFractionDigits = maxFractionDigits
        
        let formattingText = numberFormat.string(from: NSNumber(value: tempature))
        
        return formattingText?.appending("°")
    }
}

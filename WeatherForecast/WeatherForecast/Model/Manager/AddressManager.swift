//
//  AddressManager.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/10/05.
//

import Foundation
import CoreLocation

enum AddressTranslationError: Error, LocalizedError {
    case failedToGetAddress
    case invalidAddress
    case notExistPrefferedLanguage
    
    var errorDescription: String? {
        switch self {
        case .failedToGetAddress:
            return "주소값을 얻어오는데에 실패하였습니다."
        case .invalidAddress:
            return "유효한 주소가 존재하지 않습니다."
        case .notExistPrefferedLanguage:
            return "선호 언어가 존재하지 않습니다."
        }
    }
}

struct AddressManager {
    static func generateAddress(from coordinate: CLLocation, completionHandler: @escaping (Result<String, Error>) -> Void) {
        guard let preferredLanguage = Locale.preferredLanguages.first else {
            return completionHandler(.failure(AddressTranslationError.notExistPrefferedLanguage))
        }
        let locale = Locale(identifier: preferredLanguage)
        CLGeocoder().reverseGeocodeLocation(coordinate, preferredLocale: locale) { placeMarks, error in
            if let error = error {
                return completionHandler(.failure(error))
            }
            guard let placeMarks = placeMarks, let address = placeMarks.last else {
                return completionHandler(.failure(AddressTranslationError.failedToGetAddress))
            }
            guard let adminstrativeArea = address.administrativeArea, let locality = address.locality, let thoroughfare = address.thoroughfare else {
                return completionHandler(.failure(AddressTranslationError.invalidAddress))
            }
            let userAddress = "\(adminstrativeArea) \(locality) \(thoroughfare)"
            completionHandler(.success(userAddress))
        }
    }
}

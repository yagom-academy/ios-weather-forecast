//
//  GeocoderManager.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/13.
//

import Foundation
import CoreLocation

enum GeocoderError: LocalizedError {
    case emptyPlacemarks
    
    var errorDescription: String? {
        switch self {
        case .emptyPlacemarks:
            return "Cannot reverse Geocode Location"
        }
    }
}

class GeocoderManager {
    private let geocoder: GeocoderProtocol
    
    init(geocoder: GeocoderProtocol = CLGeocoder()) {
        self.geocoder = geocoder
    }
    
    func requestAddress(on coordinate: CLLocationCoordinate2D,
                        completion: @escaping (Result<CLPlacemark, Error>) -> Void) {
        let targetLocation = CLLocation(coordinate: coordinate)
        let locale = Locale(identifier: "Ko-kr")

        geocoder.reverseGeocodeLocation(targetLocation, preferredLocale: locale) { (placemarks, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let addresses: [CLPlacemark] = placemarks,
                  let address = addresses.last else {
                completion(.failure(GeocoderError.emptyPlacemarks))
                return
            }
                                            
            completion(.success(address))
        }
    }
}

extension CLLocation {
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

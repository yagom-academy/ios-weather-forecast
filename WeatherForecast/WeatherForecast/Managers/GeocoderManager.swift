//
//  GeocoderManager.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/13.
//

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

class GeocoderManager: NSObject, CLLocationManagerDelegate {
    private let geocoder: GeocoderProtocol
    private var debounceWorkItem: DispatchWorkItem?
    
    weak var delegate: GeocoderManagible?
    
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

// MARK: - CLLocationManagerDelegate
extension GeocoderManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        
        debounceWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard let this = self else { return }
            this.delegate?.updateCoordiante(coordinate: currentLocation.coordinate)
        }
        
        debounceWorkItem = requestWorkItem
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: requestWorkItem)
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODOs: 좌표정보 직접 입력받거나 현재 위치 재설정 알럿 띄우기
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        @unknown default:
            break
        }
    }
}

extension CLLocation {
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

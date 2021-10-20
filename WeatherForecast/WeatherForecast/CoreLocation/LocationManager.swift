//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/07.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation()
    func authorizationRejected()
}

enum LocationManagerError: Error {
    case emptyPlacemark
    case invalidLocation
}

class LocationManager: NSObject {
    private var manager = CLLocationManager()
    private var currentLocation: CLLocation?
    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func getCoordinate() -> CLLocationCoordinate2D? {
        return currentLocation?.coordinate
    }

    func getAddress(location: CLLocation, completion: @escaping (Result<CLPlacemark, Error>) -> Void) {
        var preferredLocale: Locale
        if let lang = Locale.preferredLanguages.first {
            preferredLocale = Locale(identifier: lang)
        } else {
            preferredLocale = Locale(identifier: "ko_KR")
        }

        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: preferredLocale) { placemark, error in
            guard error == nil else {
                return completion(.failure(LocationManagerError.invalidLocation))
            }
            guard let placemark = placemark?.last else {
                return completion(.failure(LocationManagerError.emptyPlacemark))
            }
            completion(.success(placemark))
        }
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func isAuthorizationAllowed() -> Bool {
        let authorizationStatus: CLAuthorizationStatus

        if #available(iOS 14, *) {
            authorizationStatus = manager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied, .restricted:
            return false
        default:
            return false
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            debugPrint("권한받음")
            manager.requestLocation()
        case .denied, .restricted:
            debugPrint("권한없음")
            delegate?.authorizationRejected()
        default:
            debugPrint("알수없음")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        currentLocation = location
        delegate?.didUpdateLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}

//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/07.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation()
}

enum LocationManagerError: Error {
    case emptyPlacemark
    case invalidLocation
}

class LocationManager: NSObject {
    private var manager: CLLocationManager?
    private var currentLocation: CLLocation?
    weak var delegate: LocationManagerDelegate?

    init(manager: CLLocationManager = CLLocationManager()) {
        super.init()
        self.manager = manager
        self.manager?.delegate = self
        self.manager?.desiredAccuracy = kCLLocationAccuracyBest
    }

    func getCoordinate() -> CLLocationCoordinate2D? {
        return currentLocation?.coordinate
    }

    func getAddress(completion: @escaping (Result<CLPlacemark, Error>) -> Void) {
        guard let currentLocation = currentLocation else {
            return
        }
        var preferredLocale: Locale
        if let lang = Locale.preferredLanguages.first {
            preferredLocale = Locale(identifier: lang)
        } else {
            preferredLocale = Locale(identifier: "ko_KR")
        }

        CLGeocoder().reverseGeocodeLocation(currentLocation, preferredLocale: preferredLocale) { placemark, error in
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
        manager?.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            print("권한없음")
        default:
            print("알수없음")
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

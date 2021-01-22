//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    // 아이폰에서 테스트하기 위한 임시 레이블
    @IBOutlet weak var testLabel1: UILabel!
    @IBOutlet weak var testLabel2: UILabel!
    @IBOutlet weak var testLabel3: UILabel!
    
    private var currentWeather: CurrentWeather?
    private var forecastFiveDays: ForecastFiveDays?
    private let locationManager = CLLocationManager()
    private let urlManager = URLManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCLLocation()
    }
}

// MARK: Decode
extension ViewController {
    private func updateCurrentWeather(location: CLLocation) {
        guard let apiURL = urlManager.makeURL(APItype: .currentWeather, location: location) else {
            showErrorAlert(type: .invalidURL)
            return
        }

        let apiDecoder = APIJSONDecoder<CurrentWeather>()
        apiDecoder.decodeAPIData(url: apiURL) { result in
            switch result {
            case .success(let data):
                self.currentWeather = data
            case .failure(let error):
                self.showErrorAlert(type: error)
            }
            
        }
    }
    
    private func updateForecastFiveDays(location: CLLocation) {
        guard let apiURL = urlManager.makeURL(APItype: .forecastFiveDays, location: location) else {
            showErrorAlert(type: .invalidURL)
            return
        }
        
        let apiDecoder = APIJSONDecoder<ForecastFiveDays>()
        apiDecoder.decodeAPIData(url: apiURL) { result in
            switch result {
            case .success(let data):
                self.forecastFiveDays = data
            case .failure(let error):
                self.showErrorAlert(type: error)
            }
        }
    }
}

// MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    private func setCLLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locationManager.location else {
            showErrorAlert(type: .invalidLocation)
            return
        }
        
        updateCurrentWeather(location: currentLocation)

        // 아이폰에서 테스트하기 위한 코드
        self.testLabel1.text = "위도: \(currentLocation.coordinate.latitude)" + "경도: \(currentLocation.coordinate.longitude)"
        self.testLabel2.text = "\(currentWeather?.city)"
        
        convertToAddress(location: currentLocation)
    }
}

// MARK: Geocoder
extension ViewController {
    private func convertToAddress(location: CLLocation) {
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr")
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: local) { (place, error) in
            guard let address: CLPlacemark = place?.last else {
                return
            }
            
            let country = address.country ?? ""
            let administrativeArea = address.administrativeArea ??  ""
            let locality = address.locality ?? ""
            
            // 아이폰에서 테스트하기 위한 코드
            self.testLabel3.text = "\(country) \(administrativeArea) \(locality)"
        }
    }
}

extension ViewController {
    func showErrorAlert(type: InternalError) {
        let alert = UIAlertController(title: type.rawValue, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

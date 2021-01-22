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
    private func updateCurrentWeather(location: CLLocation) throws {
        guard let apiURL = urlManager.makeURL(APItype: .currentWeather, location: location) else {
            throw InternalError.invalidURL
        }

        let apiDecoder = APIJSONDecoder<CurrentWeather>()
        apiDecoder.decodeAPIData(url: apiURL) { result in
            self.currentWeather = result
        }
    }
    
    private func updateForecastFiveDays(location: CLLocation) throws {
        guard let apiURL = urlManager.makeURL(APItype: .forecastFiveDays, location: location) else {
            throw InternalError.invalidURL
        }
        
        let apiDecoder = APIJSONDecoder<ForecastFiveDays>()
        apiDecoder.decodeAPIData(url: apiURL) { result in
            self.forecastFiveDays = result
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
            return
        }
        
        do {
            try updateCurrentWeather(location: currentLocation)
        } catch {
            print(error)
        }
        
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

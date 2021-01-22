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
    
    var currentWeather: CurrentWeather?
    var forecastFiveDays: ForecastFiveDays?
    let locationManager = CLLocationManager()
//    let geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCLLocation()
    }
}

// MARK: Decode
extension ViewController {
    func updateCurrentWeather(location: CLLocation) throws {
        let apiURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=f08f782b840c2494b77e036d6bf2f3de"
        guard let url = URL(string: apiURL) else {
            throw InternalError.invalidURL
        }

        let apiDecoder = APIJSONDecoder<CurrentWeather>()
        apiDecoder.decodeAPIData(url: url) { result in
            self.currentWeather = result
        }
    }
    
    func updateForecastFiveDays(location: CLLocation) throws {
        let apiURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=f08f782b840c2494b77e036d6bf2f3de"
        guard let url = URL(string: apiURL) else {
            throw InternalError.invalidURL
        }

        let apiDecoder = APIJSONDecoder<ForecastFiveDays>()
        apiDecoder.decodeAPIData(url: url) { result in
            self.forecastFiveDays = result
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func setCLLocation() {
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

extension ViewController {
    func convertToAddress(location: CLLocation) {
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr")
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: local) { (place, error) in
            guard let address: CLPlacemark = place?.last else {
                return
            }
            guard let country = address.country, let administrativeArea = address.administrativeArea, let locality = address.locality else {
                return
            }
            
            // 아이폰에서 테스트하기 위한 코드
            self.testLabel3.text = "\(country) \(administrativeArea) \(locality)"
        }
    }
}

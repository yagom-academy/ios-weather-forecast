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
    
    var currentWeather: CurrentWeather?
    var forecastFiveDays: ForecastFiveDays?
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()

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
        guard let location = locationManager.location else {
            return
        }
        
        do {
            try updateCurrentWeather(location: location)
        } catch {
            print(error)
        }
        
        // 아이폰에서 테스트하기 위한 코드
        self.testLabel1.text = "위도: \(location.coordinate.latitude)" + "경도: \(location.coordinate.longitude)"
        self.testLabel2.text = "\(currentWeather?.city)"
    }
}
//
//extension ViewController {
//    func geo()  {
//        geocoder.reverseGeocodeLocation(location) { ([CLPlacemark]?, Error?) in
//            <#code#>
//        }
//    }
//}

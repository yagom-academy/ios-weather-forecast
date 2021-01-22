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
    
    var latitude: Double?
    var longitude: Double?
    var currentWeather: CurrentWeather?
    var forecastFiveDays: ForecastFiveDays?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCLLocation()
    }
    

}

// MARK: Decode
extension ViewController {
    func updateCurrentWeather(latitude: Double, longitude: Double) throws {
        let apiURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=f08f782b840c2494b77e036d6bf2f3de"
        guard let url = URL(string: apiURL) else {
            throw InternalError.invalidURL
        }

        let apiDecoder = APIJSONDecoder<CurrentWeather>()
        apiDecoder.decodeAPIData(url: url) { result in
            self.currentWeather = result
        }
    }
    
    func updateForecastFiveDays(latitude: Double, longitude: Double) throws {
        let apiURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=f08f782b840c2494b77e036d6bf2f3de"
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
        guard let coordinate  = locationManager.location?.coordinate else {
            return
        }
        
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        
        // 아이폰에서 테스트하기 위한 코드
        self.testLabel1.text = "위도: \(latitude!)"
        self.testLabel2.text = "경도: \(longitude!)"
    }
}

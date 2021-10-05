//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private let locationManager = LocationManager()
    lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    var data: FiveDaysForecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.askUserLocation()
        locationManager.delegate = self
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let networkManager = NetworkManager()
        
        guard let longitude = manager.location?.coordinate.longitude,
              let latitude = manager.location?.coordinate.latitude,
              let fiveDaysUrl = URL(string: "http://api.openweathermap.org/data/2.5/forecast") else  {
            return
        }
        
        let requestInfo: Parameters = ["lat": latitude, "lon": longitude, "appid": networkManager.apiKey]

        let fiveDaysWeatherApi = WeatherApi(httpTask: .request(withUrlParameters: requestInfo), httpMethod: .get, baseUrl: fiveDaysUrl)
        
        networkManager.getFiveDaysForecastData(weatherAPI: fiveDaysWeatherApi, session)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            showAlert()
            break
        case .authorizedWhenInUse:
            break
        case .authorizedAlways:
            break
        case .notDetermined:
            break
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "경고", message: "위치를 찾을 수 없습니다.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Test", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        do {
            let decodedData = try JSONDecoder().decode(FiveDaysForecast.self, from: data)
            self.data = decodedData
        } catch {
            showAlert()
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            showAlert()
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if let response = response as? HTTPURLResponse,
           (200..<300).contains(response.statusCode) {
            completionHandler(.allow)
        } else {
            completionHandler(.cancel)
        }
    }
}

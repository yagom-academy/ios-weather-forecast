//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private let networkManager = NetworkManager()
    private let locationManager = LocationManager()
    private lazy var session: URLSession = {
        let customConfiguration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            return configuration
        }()
        
        let session = URLSession(configuration: customConfiguration, delegate: self, delegateQueue: nil)
       
        return session
    }()
    
    private var fiveDaysForcastData: FiveDaysForecast?
    private var location = (longitude: CLLocationDegrees() , latitude: CLLocationDegrees())
    
    private lazy var address: String = {
        let location = CLLocation(latitude: self.location.latitude, longitude: self.location.longitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { placeMarks, error in
            guard error == nil else {
                return
            }
            
            guard let addresses = placeMarks,
                  let address = addresses.last?.name else {
                return
            }
        }
        return address
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.askUserLocation()
        locationManager.delegate = self
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let groupOne = DispatchGroup()
        
        let item = DispatchWorkItem {
            self.requestFiveDaysForcastData()
        }
        
        groupOne.enter()
        DispatchQueue.global().async(group: groupOne) {
            guard let longitude = manager.location?.coordinate.longitude,
                  let latitude = manager.location?.coordinate.latitude else {
                return
            }
            self.location.longitude = longitude
            self.location.latitude = latitude
            groupOne.leave()
        }
        
        groupOne.notify(queue: DispatchQueue.global(), work: item)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "🙋‍♀️", message: "새로고침을 해주세요.")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            showAlert(title: "❌", message: "날씨 정보를 사용 할 수 없습니다.")
            break
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            manager.requestLocation()
            break
        @unknown default:
            showAlert(title: "🌟", message: "애플이 새로운 정보를 추가했군요! 확인 해 봅시다😄")
        }
    }
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: URLSessionDataDelegate {
    private func requestFiveDaysForcastData() {
        guard let fiveDaysUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast") else {
            return
        }
        let requestInfo: Parameters = ["lat": self.location.latitude , "lon": self.location.longitude, "appid": networkManager.apiKey]
        
        let fiveDaysWeatherApi = WeatherApi(httpTask: .request(withUrlParameters: requestInfo), httpMethod: .get, baseUrl: fiveDaysUrl)
        
        networkManager.getCurrentWeatherData(weatherAPI: fiveDaysWeatherApi, self.session)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            showAlert(title: "🥲", message: "네트워크가 불안정 합니다.")
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        let requestData = proposedResponse.data
        
        do  {
            let decodedData = try Parser().decode(requestData, to: FiveDaysForecast.self)
            self.fiveDaysForcastData = decodedData
        } catch {
            showAlert(title: "🤔", message: "개발자에게 문의해 주세요")
        }
        
        completionHandler(proposedResponse)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse else {
            return
        }
        
        switch response.statusCode {
        case 200..<300:
            completionHandler(.allow)
        case 400:
            print("잘못된 요청입니다.")
            completionHandler(.cancel)
        case 401:
            print("인증이 잘못되었습니다.")
            completionHandler(.cancel)
        case 403:
            print("해당 정보에 접근할 수 없습니다. ")
            completionHandler(.cancel)
        case 500...:
            print("서버에러")
            completionHandler(.cancel)
        default:
            completionHandler(.cancel)
        }
    }
}

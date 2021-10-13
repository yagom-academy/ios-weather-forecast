//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private let networkManager = WeatherNetworkManager()
    private let locationManager = LocationManager()
    private var location = (longitude: CLLocationDegrees() , latitude: CLLocationDegrees())
    private var fiveDaysForcastData: FiveDaysForecastData?
    
    private lazy var tableView : UITableView = {
       let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.bounds = self.view.frame
        return tableView
    }()
    
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
}

extension ViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            showAlert(title: "🥲", message: "네트워크가 불안정 합니다.")
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        let requestData = proposedResponse.data
        
        do  {
            let decodedData = try Parser().decode(requestData, to: FiveDaysForecastData.self)
            self.fiveDaysForcastData = decodedData
        } catch {
            showAlert(title: "🤔", message: "개발자에게 문의해 주세요")
        }
        
        completionHandler(proposedResponse)
    }
}


extension ViewController {
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

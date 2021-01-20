//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    var locationManager: CLLocationManager!
    var latitude: Double?
    var longitude: Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserCoordinate()
        guard let userLatitude = latitude, let userLongitude = longitude else {
            return
        }
        WeatherAPI.find(userLatitude, userLongitude) { currentWeatherInfo in
            //테이블뷰?
        }
        print("위치정보 \(userLatitude), \(userLongitude)")
    }
}

extension ViewController: CLLocationManagerDelegate { //사용자위치정보셋
    func setUserCoordinate() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //포그라운드일때 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        //베터라에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //위치업데이트
        locationManager.startUpdatingLocation()
        //위경도 가져오기
        let coor = locationManager.location?.coordinate
        latitude = coor?.latitude
        longitude = coor?.longitude
    }
}



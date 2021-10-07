//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private var networkManager = NetworkManager()
    private let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        // Do any additional setup after loading the view.
    }
    
    
    private func getAddress(of location: CLLocation?) -> [Address: String] {
        var address = [Address: String]()
        locationManager.getAddress(of: location) { result in
            switch result {
            case .success(let addressElements):
                address = addressElements
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
        return address
    }
    
    private func initData() {
        let location = locationManager.getGeographicCoordinates()
        let address = getAddress(of: location)
    }
}

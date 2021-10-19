//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class MainViewController: UIViewController {
    
    private let tableViewController = TableViewController()
    private let locationViewController = LocationViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllers()
    }

    private func addViewControllers() {
        add(tableViewController)
        add(locationViewController)
        self.view.addSubview(tableViewController.view)
        tableViewController.view.frame = self.view.bounds
    }
}

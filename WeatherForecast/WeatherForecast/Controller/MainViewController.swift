//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {

    private let tableViewController = TableViewController()
    private let locationViewController = LocationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllers()
//        NotificationCenter
//            .default
//            .addObserver(self,
//                         selector: #selector(showValidLocationAlert),
//                         name: .showValidLocationAlert,
//                         object: nil)
//
//        NotificationCenter
//            .default
//            .addObserver(self,
//                         selector: #selector(showInValidLocation),
//                         name: .showInValidLocationAlert,
//                         object: nil)
    }
    
    private func addViewControllers() {
        add(tableViewController)
        add(locationViewController)
        self.view.addSubview(tableViewController.view)
        tableViewController.view.frame = self.view.bounds
    }
    
//    @objc func showValidLocationAlert() {
//        self.showDetailViewController(validLocationAlert, sender: nil)
//    }
//
//    @objc private func showInValidLocation() {
//        self.showDetailViewController(inValidLocationAlert, sender: nil)
//    }
  
}

extension MainViewController {
   
}

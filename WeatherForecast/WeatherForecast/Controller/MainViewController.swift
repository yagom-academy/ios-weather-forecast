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

    private lazy var alert: UIAlertController = {
      let alert = UIAlertController(title: "위치변경", message: "날씨를 받아올 위치의 위도와 경도를 입력해주세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "변경", style: .default))
        return alert
    }()
    
    private lazy var alert2: UIAlertController = {
        let alert2 = UIAlertController(title: "위치변경", message: "변경할 좌표를 선택해주세요", preferredStyle: .alert)
        alert2.addAction(UIAlertAction(title: "변경", style: .default))
        alert2.addAction(UIAlertAction(title: "현재 위치로 재설정", style: .default))
        alert2.addAction(UIAlertAction(title: "취소", style: .cancel))
        return alert2
      }()
    
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

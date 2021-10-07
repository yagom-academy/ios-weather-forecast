//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 현재 날씨 요청 코드입니다.
        NetworkManager().request(
            endpoint: .daily,
            parameters: ["lat": 35, "lon": 139]
        ) { (result: Result<TodayWeatherInfo, Error>) in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                print(error)
            }
        }
        // MARK: - 주간 일기 예보 요청 코드입니다.
        NetworkManager().request(
            endpoint: .weekly,
            parameters: ["lat": 35, "lon": 139]
        ) { (result: Result<WeeklyWeatherForecast, Error>) in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                print(error)
            }
        }
    }
}

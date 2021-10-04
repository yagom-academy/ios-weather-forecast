//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - PR용 테스트 코드입니다 : 잘 통신되는 지 테스트해보았습니다. (Step1 이후 삭제할 예정)
//        let manager = WeatherNetworkManager(session: URLSession(configuration: .default))
//
//        guard let currentURL = WeatherAPI.current(.geographic(latitude: 37.579782781749714,
//                                                              longitude: 126.9770678199219)).makeURL() else {
//            NSLog("URL 생성 실패")
//            return
//        }
//
//        manager.fetchData(with: currentURL) { result in
//            let decoder = WeatherJSONDecoder()
//
//            switch result {
//            case .success(let data):
//                do {
//                    let instance = try decoder.decode(CurrentData.self, from: data)
//                    print(instance) // 값이 들어오는지 확인하는 부분
//                } catch {
//                    NSLog("통신 실패")
//                }
//            case .failure(let error):
//                NSLog(error.localizedDescription)
//            }
//        }
    }

}

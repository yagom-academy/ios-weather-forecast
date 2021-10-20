//
//  URLAlertController+Extension.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/15.
//

import UIKit

extension UIAlertController {
    static func makeValidLocationAlert() -> UIAlertController {
            
            let alert = UIAlertController(title: "위치변경", message: "변경할 좌표를 선택해주세요", preferredStyle: .alert)
            
            alert.addTextField { textfiled in
                textfiled.keyboardType = .numbersAndPunctuation
                textfiled.placeholder = Placeholder.latitude.text
            }
            alert.addTextField { textfiled in
                textfiled.keyboardType = .numbersAndPunctuation
                textfiled.placeholder = Placeholder.longitude.text
            }
            
            
            let changeAction = UIAlertAction(title: "변경", style: .default) { [weak alert] _ in
                guard let longitude = alert?.textFields?[1].text, let latitude = alert?.textFields?[0].text else {
                    return
                }
                let newLocation = Coordinates(longitude: Double(longitude), latitude: Double(latitude))
                NotificationCenter.default.post(name: .changeLocationNotification, object: nil, userInfo: ["newLocation" : newLocation])
            }
            let resetToCurrentLocationAction = UIAlertAction(title: "현재 위치로 재설정", style: .default) { _ in
                let newLocation = Coordinates(longitude: nil, latitude: nil)
                NotificationCenter.default.post(name: .changeLocationNotification, object: nil, userInfo: ["newLocation" : newLocation])
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            let actions = [changeAction, resetToCurrentLocationAction, cancelAction]
            for action in actions {
                alert.addAction(action)
            }
            
            return alert
        }
    
    static func makeInvalidLocationAlert() -> UIAlertController {
            
            let alert = UIAlertController(title: "위치변경",
                                          message: "날씨를 받아올 위치의 위도와 경도를 입력해주세요.",
                                          preferredStyle: .alert)
            
            alert.addTextField { textfiled in
                textfiled.keyboardType = .numbersAndPunctuation
                textfiled.placeholder = Placeholder.latitude.text
            }
            alert.addTextField { textfiled in
                textfiled.keyboardType = .numbersAndPunctuation
                textfiled.placeholder = Placeholder.longitude.text
            }
            
            let changeAction = UIAlertAction(title: "변경", style: .default) { [weak alert] _ in
                guard let longitude = alert?.textFields?[1].text, let latitude = alert?.textFields?[0].text, let longitudeNumber = Double(longitude), let latitudeNumber = Double(latitude) else {
                    return
                }
                let newLocation = Coordinates(longitude: longitudeNumber, latitude: latitudeNumber)
                print(newLocation)
                NotificationCenter.default.post(name: .changeLocationNotification, object: nil, userInfo: ["newLocation" : newLocation])
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            let actions = [cancelAction, changeAction]
            actions.forEach { alert.addAction($0) }
            
            return alert
        }
}

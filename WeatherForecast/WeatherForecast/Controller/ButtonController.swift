//
//  ButtonController.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/19.
//

import UIKit

class ButtonController: UIViewController {
    private var button: UIButton = {
        let button = UIButton()
        button.setTitle("위치변경", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawButton()
    }
    
    private lazy var userLocationDeniedAlert: UIAlertController = {
      let alert = UIAlertController(title: "위치변경", message: "날씨를 받아올 위치의 위도와 경도를 입력해주세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "변경", style: .default))
        return alert
    }()
    
    private lazy var userLocationAcceptAlert: UIAlertController = {
        let alert2 = UIAlertController(title: "위치변경", message: "변경할 좌표를 선택해주세요", preferredStyle: .alert)
        alert2.addAction(UIAlertAction(title: "변경", style: .default))
        alert2.addAction(UIAlertAction(title: "현재 위치로 재설정", style: .default))
        alert2.addAction(UIAlertAction(title: "취소", style: .cancel))
        return alert2
      }()
}

extension ButtonController {
    func decideButtonAction(_ state: UserState) {
        switch state {
        case .able:
            chaneToAbleButton()
        case .disable:
            chaneToDisableButton()
        }
    }
    
    private func drawButton() {
        self.view.addSubview(button)
        self.button.setPosition(top: self.view.topAnchor, bottom: self.view.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor)
    }
 
    private func chaneToAbleButton() {
        button.setTitle(UserState.able.buttonTitle, for: .normal)
        button.addTarget(self,
                         action: #selector(showUserLocationAcceptAlert),
                         for: .touchUpInside)
    }
    
    @objc func showUserLocationAcceptAlert() {
        self.present(userLocationAcceptAlert, animated: true)
    }
    
    private func chaneToDisableButton() {
        button.setTitle(UserState.disable.buttonTitle, for: .normal)
        button.addTarget(self,
                         action: #selector(showUserLocationDeniedAlert),
                         for: .touchUpInside)
    }
    
    @objc func showUserLocationDeniedAlert() {
        self.present(userLocationDeniedAlert, animated: true)
    }
}

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
}

extension ButtonController {
    func drawButton() {
        self.view.addSubview(button)
        self.button.setPosition(top: self.view.topAnchor, bottom: self.view.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor)
     //   button.frame = view.bounds
    }
    
    
    
    func decideButton(_ state: UserState) {
        switch state {
        case .able:
            chaneToAbleButton()
        case .disable:
            chaneToDisableButton()
        }
    }
    
    private func chaneToDisableButton() {
        button.setTitle(UserState.disable.buttonTitle, for: .normal)
        button.addTarget(self,
                         action: #selector(showLocationInsertAlert),
                         for: .touchUpInside)
    }
    
    private func chaneToAbleButton() {
        button.setTitle(UserState.able.buttonTitle, for: .normal)
        button.addTarget(self,
                         action: #selector(showLocationChangeAlert),
                         for: .touchUpInside)
    }
    
    @objc func showLocationChangeAlert() {
        
    }
    
    @objc func showLocationInsertAlert() {
        
    }

}

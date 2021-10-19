//
//  LocationButton.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/19.
//

import UIKit

enum UserState {
    case able
    case disable
    
    var buttonTitle: String {
        switch self {
        case .able:
            return "위치변경"
        case .disable:
            return "위치설정"
        }
    }
}

class LocationButton {
    private var button: UIButton?
    
    var decidedButton: UIButton {
        return self.button ?? UIButton()
    }
    
    func decideButtonDesign(_ state: UserState) {
        switch state {
        case .able:
            makeAbleButton()
        case .disable:
            makeDisableButton()
        }
    }
    
    private func makeDisableButton() {
        self.button = {
            let button = UIButton()
            button.setTitle(UserState.disable.buttonTitle, for: .normal)
            button.setTitleColor(.blue, for: .normal)
            return button
        }()
    }
    
    private func makeAbleButton() {
        self.button = {
            let button = UIButton()
            button.setTitle(UserState.able.buttonTitle, for: .normal)
            button.setTitleColor(.blue, for: .normal)
            return button
        }()
    }
}

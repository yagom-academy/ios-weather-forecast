//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    private var networkManager = NetworkManager()
    
    private var apiKey: String? {
        guard let filePath = Bundle.main.path(forResource: APIKey.fileName, ofType: APIKey.fileExtension) else {
            presentAlertError()
            return nil
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let key = plist?.object(forKey: APIKey.fileName) as? String else {
            presentAlertError()
            return nil
        }
        return key
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func presentAlertError() {
        
    }
}


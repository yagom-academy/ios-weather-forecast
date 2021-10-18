//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainWeatherViewController: UIViewController {
    
    var currentWeatherViewModel = CurrentWeatherViewModel()
    var fiveDayWeatherViewModel = FiveDayWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBackgroundView()
        
        currentWeatherViewModel.reload()
        fiveDayWeatherViewModel.reload()
    }
    
    func initBackgroundView() {
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.image = UIImage(named: "seoul.jpeg")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        view.addSubview(imageView)
    }
}

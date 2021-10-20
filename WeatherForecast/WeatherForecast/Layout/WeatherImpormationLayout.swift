//
//  WeatherImpormationLayout.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/20.
//

import Foundation

struct WeatherImpormationLayout: CompositionalLayoutProtocol {
    var scrollDirection: ScrollDirection = .vertical
    
    var portraitHorizontalNumber: Number = .number(1)
    
    var landscapeHorizontalNumber: Number = .number(1)
    
    var cellVerticalSize: Size = .size(.fractionalHeight(1/14))
    
    var headerVerticalSize: Size = .size(.fractionalHeight(2/14))
    
    var cellMargin: Margin?
    
    var viewMargin: Margin? = .margin(top: 0, leading: 5, bottom: 0, trailing: 0)
}

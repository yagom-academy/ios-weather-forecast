//
//  CompositionalLayoutProtocol.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/20.
//

import Foundation

protocol CompositionalLayoutProtocol {
    var portraitHorizontalNumber: Number { get }
    var landscapeHorizontalNumber: Number { get }
    var cellVerticalSize: Size { get }
    var headerVerticalSize: Size { get }
    var scrollDirection: ScrollDirection { get }
    var cellMargin: Margin? { get }
    var viewMargin: Margin? { get }
}

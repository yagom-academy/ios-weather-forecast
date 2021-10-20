//
//  LauoutContents.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/20.
//

import UIKit

enum ScrollDirection {
    case horizontal
    case vertical
}

enum Number {
    case number(Int)
    
    var value: Int {
        switch self {
        case .number(let value):
            return value
        }
    }
}

enum Size {
    case size(NSCollectionLayoutDimension)
    
    var value: NSCollectionLayoutDimension {
        switch self {
        case .size(let value):
            return value
        }
    }
}

enum Margin {
    case margin(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat)
    
    var value: NSDirectionalEdgeInsets {
        switch self {
        case .margin(let top, let leaading, let bottom, let trailing):
            return NSDirectionalEdgeInsets(
                top: top, leading: leaading, bottom: bottom, trailing: trailing)
        }
    }
}

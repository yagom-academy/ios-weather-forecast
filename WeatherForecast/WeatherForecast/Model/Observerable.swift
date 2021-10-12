//
//  Observerable.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/12.
//

import Foundation

class Observerble<T> {
   private var completion: (() -> Void)?
    
    var value: T? {
        didSet {
            completion?()
        }
    }
    
    init(_ value: T? = nil) {
        self.value = value
    }
    
    func bind(_ completion: (() -> Void)?) {
        self.completion = completion
        completion?()
    }

}

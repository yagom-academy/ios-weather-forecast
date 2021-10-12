//
//  Observerable.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/12.
//

import Foundation

class Observable<T> {
   private var completion: ((T?) -> Void)?
    
    var value: T? {
        didSet {
            completion?(value)
        }
    }
    
    init(_ value: T? = nil) {
        self.value = value
    }
    
    func bind(_ completion: ((T?) -> Void)?) {
        self.completion = completion
        completion?(value)
    }

}

//
//  DebounceManager.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/22.
//

import Foundation

class DebounceManager {
    private var queue: DispatchQueue = DispatchQueue(label: "Serial")
    private var workItem = DispatchWorkItem(block: {})
    
    func processDebounce(interval: TimeInterval = 0.3, action: @escaping (() -> Void)) {
        workItem.cancel()
        workItem = DispatchWorkItem(block: { action()})
        queue.asyncAfter(deadline: .now() + interval, execute: workItem)
    }
}

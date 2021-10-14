//
//  Responsible.swift
//  WeatherForecast
//
//  Created by kjs on 2021/10/12.
//

import Foundation

protocol Requestable {
    associatedtype Path: RawRepresentable
    var path: String { get set }
    var parameters: [String: Any]? { get }
}

extension Requestable {
    var parameters: [String: Any]? {
        let mirror = Mirror(reflecting: self)
        let selfType = mirror.displayStyle

        guard selfType == .class || selfType == .struct else {
            return nil
        }

        var result = [String: Any]()
        mirror.children.forEach { child in
            if let label = child.label {
                result[label] = child.value
            }
        }
        return result
    }
}

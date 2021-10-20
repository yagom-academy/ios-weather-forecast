//
//  Requestable.swift
//  WeatherForecast
//
//  Created by kjs on 2021/10/20.
//

import Foundation

typealias Responsible = Decodable

protocol Requestable {
    associatedtype ResponseType: Responsible

    var path: String { get }
    var parameters: [String: Any] { get }

    func fetch(
        completionHandler: @escaping (Result<ResponseType, Error>) -> Void
    )
}

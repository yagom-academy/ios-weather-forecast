//
//  PNGRequester.swift
//  WeatherForecast
//
//  Created by kjs on 2021/10/20.
//

import UIKit

struct PNGRequester: Requestable {
    typealias ResponseType = Data

    var path: String
    var parameters: [String: Any] {
        return [:]
    }

    init(iconName: String) {
        path = iconName + ".png"
    }

    func fetch(
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        let path = EndPoint.imageBaseURL + path
        guard let url = URLGenerator.work(with: path) else {
            completionHandler(.failure(NetworkError.invalidURL))
            return
        }

        NetworkManager.shared.requestImage(with: url, completionHandler: completionHandler)
    }
}

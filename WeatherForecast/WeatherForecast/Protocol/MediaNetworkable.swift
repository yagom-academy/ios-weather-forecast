//
//  MediaNetworkable.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/13.
//

import Foundation
import UIKit.UIImage

protocol MediaNetworkable {
    func loadImage(with urlPath: String,
                   completionHandler: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask?
}

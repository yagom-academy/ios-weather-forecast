//
//  ImageCacheManager.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/21.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}

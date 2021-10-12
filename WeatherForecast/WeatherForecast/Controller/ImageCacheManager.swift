//
//  ImageCacheManager.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/13.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}

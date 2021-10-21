//
//  ImageCacheManager.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/22.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cacheUrl = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadCachedData(for key: String) -> UIImage? {
        let itemUrl = NSString(string: key)
        return cacheUrl.object(forKey: itemUrl)
    }
    
    func setData(of image: UIImage, for key: String) {
        let itemUrl = NSString(string: key)
        cacheUrl.setObject(image, forKey: itemUrl)
    }
}

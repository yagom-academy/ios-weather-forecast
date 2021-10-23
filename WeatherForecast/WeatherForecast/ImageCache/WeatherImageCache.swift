//
//  WeatherImageCache.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/16.
//

import UIKit

final class WeatherImageChche: NSCache<NSString, UIImage> {
    static let shared = WeatherImageChche()
    func setObject(forKey key: NSString, object: UIImage?) {
        guard let object = object else { return }
        self.setObject(object, forKey: key)
    }
    
    func getObject(forKey key: NSString) -> UIImage? {
        return object(forKey: key)
    }
    
    private override init() {
        super.init()
    }
}

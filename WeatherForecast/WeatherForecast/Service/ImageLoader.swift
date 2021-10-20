//
//  ImageLoader.swift
//  WeatherForecast
//
//  Created by Dasoll Park on 2021/10/20.
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private var networkManager: WeatherNetworkManager?
    private var cache: NSCache<NSString, UIImage>?
    
    private init() {
        self.networkManager = WeatherNetworkManager(session: URLSession.shared)
        self.cache = NSCache()
    }
    
    func obtainImage(cacheKey: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "https://openweathermap.org/img/w/\(cacheKey).png") else {
            print("Wrong URL")
            return
        }
        if let image = cache?.object(forKey: cacheKey as NSString) {
            completion(image)
        } else {
            networkManager?.fetchData(with: url, completion: { result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        print("Not a image")
                        completion(nil)
                        return
                    }
                    self.cache?.setObject(image, forKey: cacheKey as NSString)
                    completion(image)
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            })
        }
    }
}

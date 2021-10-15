//
//  ImageLoader.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/15.
//

import UIKit

struct ImageLoader {
    private let imageCacher: NSCache<NSString, UIImage>
    
    init(imageCacher: NSCache<NSString, UIImage>) {
        self.imageCacher = imageCacher
    }
    
    func cacheData(key: String, data: UIImage) {
        imageCacher.setObject(data, forKey: key as NSString)
    }
    
    func fetchCachedData(key: String) -> UIImage? {
        return imageCacher.object(forKey: key as NSString)
    }
    
    func imageFetch(url: URL, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            do {
                let fetchedData = try Data(contentsOf: url)
                if let iconImage = UIImage(data: fetchedData) {
                    completion(iconImage)
                } else {
                    NSLog("\(#function) - image 변환 실패")
                }
            } catch {
                NSLog("\(#function) - image 데이터 불러오기 실패")
            }
        }
    }

}

//
//  Extension + UIImageView.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/13.
//

import UIKit

extension UIImageView {
    func setImageURL(_ url: String, completion: @escaping ((NSString, UIImage) -> Void)) {
        let cacheKey = NSString(string: url)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }

        DispatchQueue.global().async {
            if let url = URL(string: url) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if error != nil {
                        DispatchQueue.main.async {
                            self.image = UIImage()
                        }
                        return
                    }
                    guard let data = data, let image = UIImage(data: data) else {
                        return
                    }
                    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                    DispatchQueue.main.async {
                        completion(cacheKey, image)
                    }
                }.resume()
            }
        }
    }
}
